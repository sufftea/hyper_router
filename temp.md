Is there any benefit to using strings as "identity keys" instead of just unique objects?

E.g.: you have a named route, but you don't want to type the string name everywhere, so you put it in a const variable: `const homeRoute = "home";`

But now you won't ever use the content of that string, so what if it was just a `conts homeRoute = UniqueKey()` instead?