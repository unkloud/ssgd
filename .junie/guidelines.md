# Project Guidelines

* Keep it simple and straightforward, no abstraction unless absolutely necessary
* Keep the dependencies only on the very reliable ones, like `vibe-d`
* Test essential functionalities, not necessary to chase 100% test coverage
* Update README.md after code change to reflect the change of usage and the user interface is affected
* Modules are designed to one thing well, with clear and easy to use interfaces
* Avoid deep class hierarchy in favour of functional composition
* Clarity is more important than performance, but performance should be made possible to optimise through modularisation
  and well defined interfaces
* Avoid excessive logging and print, keep the lines compact and leave no blank line unless absolutely necessary
* After change always run dfmt on d source files
