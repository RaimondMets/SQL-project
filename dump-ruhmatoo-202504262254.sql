--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-04-26 22:54:55

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 239 (class 1255 OID 17309)
-- Name: lisa_voistlus(character varying, date, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.lisa_voistlus(nimi character varying, kuupaev date, asukoht character varying, staatus character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO voistlus (nimi, kuupaev, asukoht, staatus)
    VALUES (nimi, kuupaev, asukoht, staatus);
END;
$$;


--
-- TOC entry 238 (class 1255 OID 17308)
-- Name: lisa_voistlus(integer, character varying, date, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.lisa_voistlus(spordiala integer, nimi character varying, kuupaev date, asukoht character varying, staatus character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO voistlus (spordiala_id, nimi, kuupaev, asukoht, staatus)
    VALUES (spordiala, nimi, kuupaev, asukoht, staatus);
END;
$$;


--
-- TOC entry 240 (class 1255 OID 17310)
-- Name: uuenda_voistluse_staatus(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.uuenda_voistluse_staatus(voistlusid integer, uusstaatus character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE voistlus
    SET staatus = uusStaatus
    WHERE voistlus_id = voistlusId;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 233 (class 1259 OID 17281)
-- Name: isik; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.isik (
    osaleja_id integer NOT NULL,
    riik character varying(50),
    nimi character varying(255),
    synniaasta date
);


--
-- TOC entry 228 (class 1259 OID 17235)
-- Name: kohtunik; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kohtunik (
    kohtunik_id integer NOT NULL,
    nimi character varying(255),
    kogemus_aastates integer
);


--
-- TOC entry 227 (class 1259 OID 17234)
-- Name: kohtunik_kohtunik_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.kohtunik_kohtunik_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 227
-- Name: kohtunik_kohtunik_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.kohtunik_kohtunik_id_seq OWNED BY public.kohtunik.kohtunik_id;


--
-- TOC entry 231 (class 1259 OID 17257)
-- Name: korraldaja; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.korraldaja (
    korraldaja_id integer NOT NULL,
    nimi character varying(255),
    organisatsioon character varying(255),
    email character varying(255)
);


--
-- TOC entry 230 (class 1259 OID 17256)
-- Name: korraldaja_korraldaja_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.korraldaja_korraldaja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 230
-- Name: korraldaja_korraldaja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.korraldaja_korraldaja_id_seq OWNED BY public.korraldaja.korraldaja_id;


--
-- TOC entry 223 (class 1259 OID 17192)
-- Name: meeskond; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meeskond (
    osaleja_id integer NOT NULL,
    nimi character varying(255),
    riik character varying(50)
);


--
-- TOC entry 222 (class 1259 OID 17176)
-- Name: osaleja; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.osaleja (
    osaleja_id integer NOT NULL,
    tyyp character varying(20)
);


--
-- TOC entry 221 (class 1259 OID 17175)
-- Name: osaleja_osaleja_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.osaleja_osaleja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 221
-- Name: osaleja_osaleja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.osaleja_osaleja_id_seq OWNED BY public.osaleja.osaleja_id;


--
-- TOC entry 235 (class 1259 OID 17295)
-- Name: osalejate_tyyp_nimi; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.osalejate_tyyp_nimi AS
 SELECT o.osaleja_id,
    o.tyyp,
    COALESCE(i.nimi, m.nimi) AS nimi
   FROM ((public.osaleja o
     LEFT JOIN public.isik i ON ((o.osaleja_id = i.osaleja_id)))
     LEFT JOIN public.meeskond m ON ((o.osaleja_id = m.osaleja_id)));


--
-- TOC entry 218 (class 1259 OID 17155)
-- Name: spordiala; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spordiala (
    spordiala_id integer NOT NULL,
    nimi character varying(255)
);


--
-- TOC entry 217 (class 1259 OID 17154)
-- Name: spordiala_spordiala_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spordiala_spordiala_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 217
-- Name: spordiala_spordiala_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spordiala_spordiala_id_seq OWNED BY public.spordiala.spordiala_id;


--
-- TOC entry 226 (class 1259 OID 17218)
-- Name: tulemus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tulemus (
    tulemus_id integer NOT NULL,
    osaleja_id integer,
    voistlus_id integer,
    koht integer,
    punktid numeric(5,2)
);


--
-- TOC entry 225 (class 1259 OID 17217)
-- Name: tulemus_tulemus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tulemus_tulemus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 225
-- Name: tulemus_tulemus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tulemus_tulemus_id_seq OWNED BY public.tulemus.tulemus_id;


--
-- TOC entry 220 (class 1259 OID 17162)
-- Name: voistlus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.voistlus (
    voistlus_id integer NOT NULL,
    spordiala_id integer,
    nimi character varying(255),
    kuupaev date,
    asukoht character varying(255),
    staatus character varying(50)
);


--
-- TOC entry 237 (class 1259 OID 17303)
-- Name: tulemuste_tabel; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.tulemuste_tabel AS
 SELECT COALESCE(i.nimi, m.nimi) AS osaleja_nimi,
    v.nimi AS voistlus_nimi,
    t.koht,
    t.punktid
   FROM ((((public.tulemus t
     JOIN public.osaleja o ON ((t.osaleja_id = o.osaleja_id)))
     LEFT JOIN public.isik i ON ((o.osaleja_id = i.osaleja_id)))
     LEFT JOIN public.meeskond m ON ((o.osaleja_id = m.osaleja_id)))
     JOIN public.voistlus v ON ((t.voistlus_id = v.voistlus_id)));


--
-- TOC entry 229 (class 1259 OID 17241)
-- Name: voistlus_kohtunik; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.voistlus_kohtunik (
    kohtunik_id integer NOT NULL,
    voistlus_id integer NOT NULL
);


--
-- TOC entry 232 (class 1259 OID 17265)
-- Name: voistlus_korraldaja; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.voistlus_korraldaja (
    voistlus_id integer NOT NULL,
    korraldaja_id integer NOT NULL,
    roll character varying(100)
);


--
-- TOC entry 224 (class 1259 OID 17202)
-- Name: voistlus_osaleja; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.voistlus_osaleja (
    voistlus_id integer NOT NULL,
    osaleja_id integer NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 17161)
-- Name: voistlus_voistlus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.voistlus_voistlus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 219
-- Name: voistlus_voistlus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.voistlus_voistlus_id_seq OWNED BY public.voistlus.voistlus_id;


--
-- TOC entry 236 (class 1259 OID 17299)
-- Name: voistlused_kohtunikud; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.voistlused_kohtunikud AS
 SELECT v.nimi AS voistlus_nimi,
    k.nimi AS kohtunik_nimi
   FROM ((public.voistlus v
     JOIN public.voistlus_kohtunik vk ON ((v.voistlus_id = vk.voistlus_id)))
     JOIN public.kohtunik k ON ((vk.kohtunik_id = k.kohtunik_id)));


--
-- TOC entry 234 (class 1259 OID 17291)
-- Name: voistlused_spordialad; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.voistlused_spordialad AS
 SELECT v.voistlus_id,
    v.nimi AS voistlus_nimi,
    s.nimi AS spordiala_nimi,
    v.kuupaev
   FROM (public.voistlus v
     JOIN public.spordiala s ON ((v.spordiala_id = s.spordiala_id)));


--
-- TOC entry 4709 (class 2604 OID 17238)
-- Name: kohtunik kohtunik_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kohtunik ALTER COLUMN kohtunik_id SET DEFAULT nextval('public.kohtunik_kohtunik_id_seq'::regclass);


--
-- TOC entry 4710 (class 2604 OID 17260)
-- Name: korraldaja korraldaja_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.korraldaja ALTER COLUMN korraldaja_id SET DEFAULT nextval('public.korraldaja_korraldaja_id_seq'::regclass);


--
-- TOC entry 4707 (class 2604 OID 17179)
-- Name: osaleja osaleja_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.osaleja ALTER COLUMN osaleja_id SET DEFAULT nextval('public.osaleja_osaleja_id_seq'::regclass);


--
-- TOC entry 4705 (class 2604 OID 17158)
-- Name: spordiala spordiala_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spordiala ALTER COLUMN spordiala_id SET DEFAULT nextval('public.spordiala_spordiala_id_seq'::regclass);


--
-- TOC entry 4708 (class 2604 OID 17221)
-- Name: tulemus tulemus_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tulemus ALTER COLUMN tulemus_id SET DEFAULT nextval('public.tulemus_tulemus_id_seq'::regclass);


--
-- TOC entry 4706 (class 2604 OID 17165)
-- Name: voistlus voistlus_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus ALTER COLUMN voistlus_id SET DEFAULT nextval('public.voistlus_voistlus_id_seq'::regclass);


--
-- TOC entry 4909 (class 0 OID 17281)
-- Dependencies: 233
-- Data for Name: isik; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.isik VALUES (1, 'Eesti', 'Jaan Tamm', '2004-04-05');
INSERT INTO public.isik VALUES (3, 'Läti', 'Marta Ozola', '2002-03-15');


--
-- TOC entry 4904 (class 0 OID 17235)
-- Dependencies: 228
-- Data for Name: kohtunik; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.kohtunik VALUES (1, 'Peeter Põld', 10);
INSERT INTO public.kohtunik VALUES (2, 'Mari Maasikas', 5);
INSERT INTO public.kohtunik VALUES (3, 'Karl Kask', 7);
INSERT INTO public.kohtunik VALUES (4, 'Liis Lepik', 3);


--
-- TOC entry 4907 (class 0 OID 17257)
-- Dependencies: 231
-- Data for Name: korraldaja; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.korraldaja VALUES (1, 'Siim Saar', 'Spordiühing', 'siim.saar@gmail.com');
INSERT INTO public.korraldaja VALUES (2, 'Anna Aas', 'Tallinna Spordikool', 'anna.aas@gmail.com');
INSERT INTO public.korraldaja VALUES (3, 'Marko Mets', 'Tartu Spordiselts', 'marko.mets@gmail.com');
INSERT INTO public.korraldaja VALUES (4, 'Linda Lumi', 'Pärnu Tennisekeskus', 'linda.lumi@gmail.com');


--
-- TOC entry 4899 (class 0 OID 17192)
-- Dependencies: 223
-- Data for Name: meeskond; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.meeskond VALUES (2, 'Tallinna Wolves', 'Eesti');
INSERT INTO public.meeskond VALUES (4, 'Riga Rockets', 'Läti');


--
-- TOC entry 4898 (class 0 OID 17176)
-- Dependencies: 222
-- Data for Name: osaleja; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.osaleja VALUES (1, 'isik');
INSERT INTO public.osaleja VALUES (2, 'meeskond');
INSERT INTO public.osaleja VALUES (3, 'isik');
INSERT INTO public.osaleja VALUES (4, 'meeskond');


--
-- TOC entry 4894 (class 0 OID 17155)
-- Dependencies: 218
-- Data for Name: spordiala; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.spordiala VALUES (1, 'Jalgpall');
INSERT INTO public.spordiala VALUES (2, 'Korvpall');
INSERT INTO public.spordiala VALUES (3, 'Tennis');
INSERT INTO public.spordiala VALUES (4, 'Suusatamine');
INSERT INTO public.spordiala VALUES (5, 'Rattasõit');


--
-- TOC entry 4902 (class 0 OID 17218)
-- Dependencies: 226
-- Data for Name: tulemus; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tulemus VALUES (1, 2, 1, 1, 85.50);
INSERT INTO public.tulemus VALUES (2, 1, 2, 2, 78.00);
INSERT INTO public.tulemus VALUES (3, 3, 3, 1, 92.30);
INSERT INTO public.tulemus VALUES (4, 4, 4, 3, 60.75);


--
-- TOC entry 4896 (class 0 OID 17162)
-- Dependencies: 220
-- Data for Name: voistlus; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.voistlus VALUES (2, 2, 'Tartu Slam', '2025-07-10', 'Tartu', 'Toimunud');
INSERT INTO public.voistlus VALUES (3, 3, 'Pärnu Open', '2025-08-05', 'Pärnu', 'Planeeritud');
INSERT INTO public.voistlus VALUES (4, 4, 'Otepää Winter Games', '2025-12-01', 'Otepää', 'Tühistatud');
INSERT INTO public.voistlus VALUES (14, 5, 'Tour de Viljandi', '2025-04-01', 'Viljandi', 'Toimunud');
INSERT INTO public.voistlus VALUES (15, 1, 'Viljandi Maraton', '2025-09-15', 'Viljandi', 'Planeeritud');
INSERT INTO public.voistlus VALUES (1, 1, 'Tallinna Cup', '2025-06-15', 'Tallinn', 'Toimunud');


--
-- TOC entry 4905 (class 0 OID 17241)
-- Dependencies: 229
-- Data for Name: voistlus_kohtunik; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.voistlus_kohtunik VALUES (1, 1);
INSERT INTO public.voistlus_kohtunik VALUES (2, 2);
INSERT INTO public.voistlus_kohtunik VALUES (3, 3);
INSERT INTO public.voistlus_kohtunik VALUES (4, 4);


--
-- TOC entry 4908 (class 0 OID 17265)
-- Dependencies: 232
-- Data for Name: voistlus_korraldaja; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.voistlus_korraldaja VALUES (1, 1, 'Peakorraldaja');
INSERT INTO public.voistlus_korraldaja VALUES (2, 2, 'Assistent');
INSERT INTO public.voistlus_korraldaja VALUES (3, 3, 'Peakorraldaja');
INSERT INTO public.voistlus_korraldaja VALUES (4, 4, 'Logistik');


--
-- TOC entry 4900 (class 0 OID 17202)
-- Dependencies: 224
-- Data for Name: voistlus_osaleja; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.voistlus_osaleja VALUES (1, 2);
INSERT INTO public.voistlus_osaleja VALUES (2, 1);
INSERT INTO public.voistlus_osaleja VALUES (3, 3);
INSERT INTO public.voistlus_osaleja VALUES (4, 4);


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 227
-- Name: kohtunik_kohtunik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.kohtunik_kohtunik_id_seq', 4, true);


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 230
-- Name: korraldaja_korraldaja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.korraldaja_korraldaja_id_seq', 4, true);


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 221
-- Name: osaleja_osaleja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.osaleja_osaleja_id_seq', 4, true);


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 217
-- Name: spordiala_spordiala_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.spordiala_spordiala_id_seq', 5, true);


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 225
-- Name: tulemus_tulemus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tulemus_tulemus_id_seq', 4, true);


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 219
-- Name: voistlus_voistlus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.voistlus_voistlus_id_seq', 18, true);


--
-- TOC entry 4732 (class 2606 OID 17285)
-- Name: isik isik_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.isik
    ADD CONSTRAINT isik_pkey PRIMARY KEY (osaleja_id);


--
-- TOC entry 4724 (class 2606 OID 17240)
-- Name: kohtunik kohtunik_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kohtunik
    ADD CONSTRAINT kohtunik_pkey PRIMARY KEY (kohtunik_id);


--
-- TOC entry 4728 (class 2606 OID 17264)
-- Name: korraldaja korraldaja_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.korraldaja
    ADD CONSTRAINT korraldaja_pkey PRIMARY KEY (korraldaja_id);


--
-- TOC entry 4718 (class 2606 OID 17196)
-- Name: meeskond meeskond_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeskond
    ADD CONSTRAINT meeskond_pkey PRIMARY KEY (osaleja_id);


--
-- TOC entry 4716 (class 2606 OID 17181)
-- Name: osaleja osaleja_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.osaleja
    ADD CONSTRAINT osaleja_pkey PRIMARY KEY (osaleja_id);


--
-- TOC entry 4712 (class 2606 OID 17160)
-- Name: spordiala spordiala_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spordiala
    ADD CONSTRAINT spordiala_pkey PRIMARY KEY (spordiala_id);


--
-- TOC entry 4722 (class 2606 OID 17223)
-- Name: tulemus tulemus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tulemus
    ADD CONSTRAINT tulemus_pkey PRIMARY KEY (tulemus_id);


--
-- TOC entry 4726 (class 2606 OID 17245)
-- Name: voistlus_kohtunik voistlus_kohtunik_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_kohtunik
    ADD CONSTRAINT voistlus_kohtunik_pkey PRIMARY KEY (kohtunik_id, voistlus_id);


--
-- TOC entry 4730 (class 2606 OID 17269)
-- Name: voistlus_korraldaja voistlus_korraldaja_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_korraldaja
    ADD CONSTRAINT voistlus_korraldaja_pkey PRIMARY KEY (voistlus_id, korraldaja_id);


--
-- TOC entry 4720 (class 2606 OID 17206)
-- Name: voistlus_osaleja voistlus_osaleja_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_osaleja
    ADD CONSTRAINT voistlus_osaleja_pkey PRIMARY KEY (voistlus_id, osaleja_id);


--
-- TOC entry 4714 (class 2606 OID 17169)
-- Name: voistlus voistlus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus
    ADD CONSTRAINT voistlus_pkey PRIMARY KEY (voistlus_id);


--
-- TOC entry 4743 (class 2606 OID 17286)
-- Name: isik isik_osaleja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.isik
    ADD CONSTRAINT isik_osaleja_id_fkey FOREIGN KEY (osaleja_id) REFERENCES public.osaleja(osaleja_id);


--
-- TOC entry 4734 (class 2606 OID 17197)
-- Name: meeskond meeskond_osaleja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeskond
    ADD CONSTRAINT meeskond_osaleja_id_fkey FOREIGN KEY (osaleja_id) REFERENCES public.osaleja(osaleja_id);


--
-- TOC entry 4737 (class 2606 OID 17224)
-- Name: tulemus tulemus_osaleja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tulemus
    ADD CONSTRAINT tulemus_osaleja_id_fkey FOREIGN KEY (osaleja_id) REFERENCES public.osaleja(osaleja_id);


--
-- TOC entry 4738 (class 2606 OID 17229)
-- Name: tulemus tulemus_voistlus_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tulemus
    ADD CONSTRAINT tulemus_voistlus_id_fkey FOREIGN KEY (voistlus_id) REFERENCES public.voistlus(voistlus_id);


--
-- TOC entry 4739 (class 2606 OID 17246)
-- Name: voistlus_kohtunik voistlus_kohtunik_kohtunik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_kohtunik
    ADD CONSTRAINT voistlus_kohtunik_kohtunik_id_fkey FOREIGN KEY (kohtunik_id) REFERENCES public.kohtunik(kohtunik_id);


--
-- TOC entry 4740 (class 2606 OID 17251)
-- Name: voistlus_kohtunik voistlus_kohtunik_voistlus_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_kohtunik
    ADD CONSTRAINT voistlus_kohtunik_voistlus_id_fkey FOREIGN KEY (voistlus_id) REFERENCES public.voistlus(voistlus_id);


--
-- TOC entry 4741 (class 2606 OID 17275)
-- Name: voistlus_korraldaja voistlus_korraldaja_korraldaja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_korraldaja
    ADD CONSTRAINT voistlus_korraldaja_korraldaja_id_fkey FOREIGN KEY (korraldaja_id) REFERENCES public.korraldaja(korraldaja_id);


--
-- TOC entry 4742 (class 2606 OID 17270)
-- Name: voistlus_korraldaja voistlus_korraldaja_voistlus_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_korraldaja
    ADD CONSTRAINT voistlus_korraldaja_voistlus_id_fkey FOREIGN KEY (voistlus_id) REFERENCES public.voistlus(voistlus_id);


--
-- TOC entry 4735 (class 2606 OID 17212)
-- Name: voistlus_osaleja voistlus_osaleja_osaleja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_osaleja
    ADD CONSTRAINT voistlus_osaleja_osaleja_id_fkey FOREIGN KEY (osaleja_id) REFERENCES public.osaleja(osaleja_id);


--
-- TOC entry 4736 (class 2606 OID 17207)
-- Name: voistlus_osaleja voistlus_osaleja_voistlus_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus_osaleja
    ADD CONSTRAINT voistlus_osaleja_voistlus_id_fkey FOREIGN KEY (voistlus_id) REFERENCES public.voistlus(voistlus_id);


--
-- TOC entry 4733 (class 2606 OID 17170)
-- Name: voistlus voistlus_spordiala_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voistlus
    ADD CONSTRAINT voistlus_spordiala_id_fkey FOREIGN KEY (spordiala_id) REFERENCES public.spordiala(spordiala_id);


-- Completed on 2025-04-26 22:54:56

--
-- PostgreSQL database dump complete
--

