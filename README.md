# Objectives

Build a small example phoenix application which uses a dynamically configured
set of allowed hosts to drive host validation (within the endpoint and socket)
as well url generation (for views).

# Implementation
In order to meet the objectives, the following things will have to be built:

* a plug to use within the endpoint that validates that we only serve if the
  hostname is allowed
* a custom socket transport which uses the dynamic configuration to check if
  the browser provided origin is one of the allowed hostnames
* a helper module for controllers/views which generates urls just like the
  default one but taking the dynamic configuration into account
