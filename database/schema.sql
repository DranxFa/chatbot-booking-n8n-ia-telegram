-- Creación de la tabla usuarios
CREATE TABLE public.usuarios (
  telegram_id bigint NOT NULL,
  nombre text,
  telefono text,
  username_telegram text,
  estado_conversacion text DEFAULT 'menu'::text,
  contexto_temporal jsonb DEFAULT '{}'::jsonb,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now(),
  CONSTRAINT usuarios_pkey PRIMARY KEY (telegram_id)
);

-- Creación de la tabla citas
CREATE TABLE public.citas (
  id SERIAL NOT NULL,
  telegram_id bigint,
  fecha_hora timestamp without time zone,
  mascota text,
  especie text,
  servicio text,
  estado_cita text DEFAULT 'programada'::text,
  recordatorio_enviado boolean DEFAULT false,
  created_at timestamp without time zone DEFAULT now(),
  calendar_event_id text,
  CONSTRAINT citas_pkey PRIMARY KEY (id),
  CONSTRAINT citas_telegram_id_fkey FOREIGN KEY (telegram_id) 
    REFERENCES public.usuarios(telegram_id) ON DELETE CASCADE
);

-- Función para actualizar el timestamp
CREATE OR REPLACE FUNCTION actualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger asociado a la tabla usuarios
CREATE TRIGGER trigger_updated_at
BEFORE UPDATE ON usuarios
FOR EACH ROW
EXECUTE FUNCTION actualizar_updated_at();