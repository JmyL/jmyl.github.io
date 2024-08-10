+++
title = 'Why C++?'
date = 2024-08-10
draft = false
authors = ['Sungsik']
categories = ['Programming']
tags = ['C++']
featuredImage = 'images/C++_logo.png'
+++

You probably saw an article that said, "You should replace C++ with a memory-safe language." This came from the U.S. government, maybe two months ago. C++ is often criticized due to its memory vulnerabilities. I'll try to defend C++.

<!--more-->
## For Programmers Who Are Familiar with Java or C#

Every criticism of C++ is rooted in its aggressive policy, the "zero-overhead principle", double-edged sword.

There are several goals in programming, like encapsulation, polymorphism, code reuse, memory safety, etc. For example, memory safety is well accomplished by Java, but Java achieves this through garbage collection. However, this can cause delays when garbage collection occurs, making Java less suitable for real-time applications with strict latency constraints.

C++ opts for reference counting (smart pointers!) and releases memory when there are no references to an instance. With C++, you can allocate contiguous memory space and slice it for different data structure elements. This approach significantly improves program speed by increasing cache efficiency—something Java cannot do. However, to use these features effectively, you need to understand many memory-related concepts like rvalue, lvalue, forwarding reference, perfect forwarding, type traits like `decay_t`, copy constructors, and move constructors. These are challenges, no doubt, but they are certainly surmountable, and it's becoming easier to write memory-safe programs with modern C++ features.

If you're writing code for a machine with abundant resources, you might prefer Java or C#, and those languages might meet all your needs.
But if you're trying to optimize further, you should take a look at C++.
There's a lot to learn, but it will be fun.
I promise :-)

## For Programmers Who Are Familiar with C

C++ has only two more '+'s than C, so many C programmers think it's just C with OOP capabilities, but that's not the case.
C++ offers many more features, like compile-time programming with templates, containers for well-known data structures, and standard algorithms that guarantee \(O(N \cdot \log N)\) runtime performance for input data of size N. In most cases, standard algorithms in C++ are faster than plain C versions because C++ algorithms are implemented with templates, which generate optimized code for your custom types (e.g., directly adding comparison logic represented with a lambda function or std::compare & projection, rather than jumping to a function which function pointer indicates).


## Rust? Zig?

For programmers who hesitate to learn C++ because Rust and Zig are so popular, I have nothing to say. Personally, I started by learning C++, and I haven't yet learned Zig or Rust. I have no idea what happens when you learn those C/C++ alternatives without knowing their predecessors. If their tutorials focus on the differences from their predecessors, then it could be annoying, but no one dies, right? :-)

And lastly, to C++ programmers, don't worry. It's not just because we have a vast amount of legacy C++ code, but because we still need a sharp tool. Even though a lack of caution can cause harm, C++ will remain essential for the next 20 years, and it's not standing still. C++20 is a completely different language compared to C++11. A smart and dedicated community continues to improve C++, and the progress so far has been pretty awesome.
Oh, I forgot to mention that there are plenty of libraries in the C++ world. C++ has the most powerful library ecosystem compared to any other programming language.

