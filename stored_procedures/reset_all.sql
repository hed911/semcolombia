DELETE FROM public.notificacions;
DELETE FROM public.ingresos;
DELETE FROM public.remisions;
DELETE FROM public.super_remisions;
DELETE FROM public.autorizacions;
UPDATE public.camas SET estado=1;

DELETE FROM public.historial_ambulancias;
DELETE FROM public.eventos_ambulatorios;
DELETE FROM public.caso_deportivos WHERE DATE(created_at) = '2018-07-18';
DELETE FROM public.traslados;
DELETE FROM public.logs WHERE ambulancia_id IS NOT NULL;



-- BORRAR LOS CASOS QUE NO SEAN DEL DIA DE HOY
DELETE FROM public.ingresos WHERE DATE(created_at) != '2018-07-18';
DELETE FROM public.remisions WHERE DATE(created_at) != '2018-07-18';
DELETE FROM public.super_remisions WHERE DATE(created_at) != '2018-07-18';
DELETE FROM public.autorizacions WHERE DATE(created_at) != '2018-07-18';
UPDATE public.camas SET estado=1;

DELETE FROM public.historial_ambulancias WHERE DATE(created_at) != '2018-07-18';
DELETE FROM public.eventos_ambulatorios WHERE DATE(created_at) != '2018-07-18';
DELETE FROM public.caso_deportivos WHERE DATE(created_at) != '2018-07-18';
DELETE FROM public.traslados WHERE DATE(created_at) != '2018-07-18';
