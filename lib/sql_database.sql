CREATE TABLE  rolles (
    id_rolle UUID DEFAULT gen_random_uuid() PRIMARY KEY,
	name_roll text not null,
	descripcion_roll text not null
)

CREATE TABLE usuario (
    id_usuario UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    full_name TEXT NOT NULL,
    type_access text default 'a',
    ocupacion TEXT NOT NULL,
    password TEXT NOT NULL,  -- Aquí almacenarás el hash de la contraseña
    usuario INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    id_rolle UUID REFERENCES rolles(id_rolle) ON DELETE CASCADE
);

CREATE TABLE modulo_permisos (
	id_modulo_permisos UUID DEFAULT gen_random_uuid() PRIMARY KEY,
	nombre_permiso text not null,
	accion_permiso text not null
);

CREATE TABLE permiso_usuario (
	id_usuario UUID not null,
	id_modulo_permisos UUID references modulo_permisos(id_modulo_permisos)
);

CREATE TABLE departments (
    id_departments UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name_department TEXT NOT NULL,
    type_access text unique not null,
    image_path text default 'N/A',
    created_at TIMESTAMP DEFAULT NOW()
);
