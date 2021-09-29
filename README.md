# Crear Function Lambda en AWS

## Variables

Modificar archivo `terraform.tfvars`.


## Ejecución Terraform 

```
1.Inicializar un directorio de trabajo 
terraform init
2.Ejecuta comprobaciones que verifican si una configuración es válida 
  No accede a ningún servicio remoto como estado remoto, API de proveedor, etc.
terraform validate
3.Comando para verificar si los cambios propuestos coinciden con lo que esperaba
  antes de aplicar los cambios.
terraform plan
4. Aplicar cambios y crear la infraestructura.
terraform apply --auto-approve


Elimina recursos
terraform destroy --auto-approve

```

