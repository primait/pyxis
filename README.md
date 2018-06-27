# Pyxis Design System


[Costellazione della bussola](https://it.wikipedia.org/wiki/Bussola_(costellazione))



### Rules:

- Css rules sorted by **alphabetic** order
- *@include*(s) and *@extend*(s) after pure rules
- No more than two nesting levels
- No implicit rules
- No vendor prefixes
- Atoms must be **predictable** and **independent** 
- Atoms must have only internal spacing
- Atoms must have active modifiers *(i.e. is-active, is-selected )*
- Stay **DRY**
- Think **mobile-first**


### Startup

Install packages: `yarn`

Run local devServer: `yarn dev` (via Webpack Dev Server)

Build for production: `yarn build:prod`
