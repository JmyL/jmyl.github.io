+++
title = 'Changing a std::map Key with extract'
date = 2026-05-27
authors = ['Sungsik']
categories = ['C++']
tags = ['C++17', 'STL', 'std::map']
featuredImage = 'images/changing-std-map-key-with-extract.png'
+++

In `std::map`, the key of an element is effectively immutable while the element is inside the container.
That is not an arbitrary restriction: the key determines where the node belongs in the map's ordered tree.
If we could freely modify a key in place, the tree ordering could become invalid.

Before C++17, changing a key usually meant removing the old element and inserting a new one:

```cpp
auto value = std::move(it->second);
m.erase(it);
m.emplace(new_key, std::move(value));
```

This works, and it can avoid copying the mapped value if `V` is movable.
But conceptually we are still replacing the map node: erase the old node, allocate a new node, and move-construct the mapped value into that new node.

C++17 gives us a cleaner tool for this case: `std::map::extract`.

## Extracting a Node

`extract` removes an element from the map and returns it as a node handle.
Once the node has been extracted, it is no longer part of the tree, so it is safe to modify its key.
After that, we can insert the same node back into the map.

```cpp
auto node = m.extract(it);
node.key() = new_key;
m.insert(std::move(node));
```

The important detail is that the node itself is reused.
The mapped value is not moved or copied, and the map does not need to destroy one node and allocate another just to change the key.

## Why This Is Different from erase + emplace

Compare the two approaches.

With `erase` + `emplace`:

- the old map node is destroyed and deallocated,
- a new map node is allocated,
- the mapped value is move-constructed into the new node.

With `extract` + `insert`:

- the existing node is removed from the tree,
- the key is modified while the node is outside the map,
- the same node is inserted again,
- the mapped value stays where it is.

That makes `extract` especially useful when the mapped value is expensive to move, non-copyable, or when we simply want the operation to express our real intent: changing the key of an existing entry.

## Insert with a Hint

If we can provide a good insertion hint, `insert` can avoid most of the tree search:

```cpp
auto node = m.extract(it);
node.key() = new_key;
m.insert(hint, std::move(node));
```

The hint is only a performance hint. When it is close to the actual insertion position, insertion can be faster. When it is wrong, the map still inserts the node correctly, but it may fall back to the usual logarithmic search.

## Takeaway

When you need to change a key in `std::map`, do not immediately reach for `erase` and `emplace`.
In C++17 and later, `extract` lets you temporarily take ownership of the map node, modify the key legally, and put the same node back.

It is a small API, but it captures the operation precisely: remove from the ordering, change the key, and reinsert into the ordering without rebuilding the value.