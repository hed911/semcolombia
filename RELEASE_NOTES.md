## RELEASE NOTES

### Version 0.0.1 - Diciembre 29, 2017

**New**

- Integracion de sistema de manejo de release notes usando la gema 'extra_extra'
- Añadida funcionalidad y gestion de perfiles para usuarios de EAPB
- Integracion de funcionalidad de 'Olvidé mi contraseña' para usuarios de secretaria de salud
- Integracion de funcionalidad de 'Olvidé mi contraseña' para usuarios IPS/EAPB
- Integracion de envio de emails de bienvenida al momento de crear una cuenta de usuario para todos los perfiles

**Fixes**

- Se eliminaron registros de la tabla de diagnosticos CIE10 porque estos agotaron el maximo que ofrece el plan de heroku
- Se arregló el problema que presenta al cargar los assets en el boot de las dos aplicaciones web, aveces no carga el CSS ni javascript

**Updates**

- Se actualizaron los assets de los logos y colores de las dos aplicaciones en el CSS
