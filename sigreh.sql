--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: enum_people_state; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_people_state AS ENUM (
    'registered',
    'waiting_formation',
    'formation',
    'internship',
    'hired',
    'reserved',
    'gave_up'
);


ALTER TYPE public.enum_people_state OWNER TO postgres;

--
-- Name: enum_users_group; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_users_group AS ENUM (
    'admin',
    'regular',
    'avaliador'
);


ALTER TYPE public.enum_users_group OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: PersonFormation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PersonFormation" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "formationId" integer NOT NULL,
    "personId" integer NOT NULL
);


ALTER TABLE public."PersonFormation" OWNER TO postgres;

--
-- Name: discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts (
    id integer NOT NULL,
    quantity double precision,
    reason character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "personId" integer,
    "userId" integer
);


ALTER TABLE public.discounts OWNER TO postgres;

--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discounts_id_seq OWNER TO postgres;

--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discounts_id_seq OWNED BY public.discounts.id;


--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluations (
    id integer NOT NULL,
    shop character varying(255),
    shift_from time without time zone,
    shift_to time without time zone,
    shop_number integer,
    date_from date,
    date_to date,
    cachier integer,
    cleaning integer,
    customer_service integer,
    replacement integer,
    team_work integer,
    cold_meats integer,
    flexibility integer,
    autonomy integer,
    punctuality integer,
    honesty integer,
    proactivity integer,
    responsability integer,
    interest_level integer,
    availability integer,
    personal_hygiene integer,
    obs text,
    responsible_hr character varying(255),
    advisor character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "personId" integer,
    "userId" integer
);


ALTER TABLE public.evaluations OWNER TO postgres;

--
-- Name: evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evaluations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluations_id_seq OWNER TO postgres;

--
-- Name: evaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evaluations_id_seq OWNED BY public.evaluations.id;


--
-- Name: formations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formations (
    id integer NOT NULL,
    name character varying(255),
    description text,
    teoric_part character varying(255),
    pratic_part character varying(255),
    subscription_cost real,
    certificate_cost real,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.formations OWNER TO postgres;

--
-- Name: formations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.formations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.formations_id_seq OWNER TO postgres;

--
-- Name: formations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formations_id_seq OWNED BY public.formations.id;


--
-- Name: increases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.increases (
    id integer NOT NULL,
    quantity double precision,
    reason character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "personId" integer,
    "userId" integer
);


ALTER TABLE public.increases OWNER TO postgres;

--
-- Name: increases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.increases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.increases_id_seq OWNER TO postgres;

--
-- Name: increases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.increases_id_seq OWNED BY public.increases.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    "toPay" real,
    paid real,
    discount real,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "personId" integer
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.people (
    id integer NOT NULL,
    name character varying(255),
    birthdate date,
    address character varying(255),
    phone character varying(255),
    email character varying(255),
    bi integer,
    nif integer,
    gender character varying(255),
    state public.enum_people_state,
    score real,
    "scoreText" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" integer
);


ALTER TABLE public.people OWNER TO postgres;

--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.people_id_seq OWNER TO postgres;

--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.session OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255),
    password character varying(255),
    "group" public.enum_users_group,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: discounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts ALTER COLUMN id SET DEFAULT nextval('public.discounts_id_seq'::regclass);


--
-- Name: evaluations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations ALTER COLUMN id SET DEFAULT nextval('public.evaluations_id_seq'::regclass);


--
-- Name: formations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formations ALTER COLUMN id SET DEFAULT nextval('public.formations_id_seq'::regclass);


--
-- Name: increases id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.increases ALTER COLUMN id SET DEFAULT nextval('public.increases_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: PersonFormation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PersonFormation" ("createdAt", "updatedAt", "formationId", "personId") FROM stdin;
2018-10-17 12:13:24.449-01	2018-10-17 12:13:24.449-01	1	2
2018-10-17 12:13:24.449-01	2018-10-17 12:13:24.449-01	2	2
2018-10-17 14:42:52.784-01	2018-10-17 14:42:52.784-01	1	4
2018-10-17 14:51:17.861-01	2018-10-17 14:51:17.861-01	1	5
2018-10-17 15:09:55.914-01	2018-10-17 15:09:55.914-01	1	6
2018-10-17 15:21:35.081-01	2018-10-17 15:21:35.081-01	1	7
2018-10-17 15:24:46.323-01	2018-10-17 15:24:46.323-01	1	8
2018-10-17 15:28:34.735-01	2018-10-17 15:28:34.735-01	1	9
2018-10-17 15:28:34.735-01	2018-10-17 15:28:34.735-01	2	9
2018-10-17 16:47:53.211-01	2018-10-17 16:47:53.211-01	1	10
2018-10-18 10:26:38.049-01	2018-10-18 10:26:38.049-01	1	12
2018-10-19 08:53:28.177-01	2018-10-19 08:53:28.177-01	1	13
2018-10-19 08:57:41.947-01	2018-10-19 08:57:41.947-01	1	14
2018-10-19 08:57:41.947-01	2018-10-19 08:57:41.947-01	2	14
2018-10-19 09:00:52.932-01	2018-10-19 09:00:52.932-01	1	15
2018-10-19 09:05:04.984-01	2018-10-19 09:05:04.984-01	1	16
2018-10-19 09:12:10.642-01	2018-10-19 09:12:10.642-01	1	17
2018-10-19 12:03:03.158-01	2018-10-19 12:03:03.158-01	1	21
2018-10-19 12:13:12.485-01	2018-10-19 12:13:12.485-01	1	22
2018-10-19 15:19:23.555-01	2018-10-19 15:19:23.555-01	1	23
2018-10-22 09:47:58.824-01	2018-10-22 09:47:58.824-01	1	24
2018-10-22 13:32:08.448-01	2018-10-22 13:32:08.448-01	1	26
2018-10-22 13:33:33.352-01	2018-10-22 13:33:33.352-01	1	27
2018-10-22 13:35:09.366-01	2018-10-22 13:35:09.366-01	1	28
2018-10-22 13:36:50.995-01	2018-10-22 13:36:50.995-01	1	29
2018-10-22 14:27:34.094-01	2018-10-22 14:27:34.094-01	1	30
2018-10-22 15:22:19.549-01	2018-10-22 15:22:19.549-01	1	31
2018-10-22 15:31:48.213-01	2018-10-22 15:31:48.213-01	1	32
2018-10-23 08:39:51.689-01	2018-10-23 08:39:51.689-01	1	33
2018-10-23 15:52:06.202-01	2018-10-23 15:52:06.202-01	1	34
2018-10-24 14:44:42.115-01	2018-10-24 14:44:42.115-01	1	35
2018-10-24 16:12:02.467-01	2018-10-24 16:12:02.467-01	1	36
2018-10-24 16:12:02.467-01	2018-10-24 16:12:02.467-01	2	36
2018-10-24 16:19:33.071-01	2018-10-24 16:19:33.071-01	1	37
2018-10-25 09:07:25.197-01	2018-10-25 09:07:25.197-01	1	39
2018-10-26 09:12:20.471-01	2018-10-26 09:12:20.471-01	1	41
2018-10-26 10:33:54.779-01	2018-10-26 10:33:54.779-01	1	42
2018-10-26 10:35:44.369-01	2018-10-26 10:35:44.369-01	1	43
2018-10-26 11:48:14.224-01	2018-10-26 11:48:14.224-01	1	44
2018-10-26 11:48:14.224-01	2018-10-26 11:48:14.224-01	2	44
2018-10-26 12:53:07.425-01	2018-10-26 12:53:07.425-01	1	45
2018-10-26 14:36:05.07-01	2018-10-26 14:36:05.07-01	1	46
2018-10-26 14:40:13.232-01	2018-10-26 14:40:13.232-01	1	47
2018-10-26 14:46:45.515-01	2018-10-26 14:46:45.515-01	1	48
2018-10-26 14:50:08.162-01	2018-10-26 14:50:08.162-01	1	49
2018-10-26 14:54:37.926-01	2018-10-26 14:54:37.926-01	1	50
2018-10-26 14:59:36.958-01	2018-10-26 14:59:36.958-01	1	51
2018-10-26 14:59:36.958-01	2018-10-26 14:59:36.958-01	2	51
2018-10-26 15:04:45.473-01	2018-10-26 15:04:45.473-01	1	52
2018-10-26 15:09:54.8-01	2018-10-26 15:09:54.8-01	1	53
2018-10-26 15:12:07.787-01	2018-10-26 15:12:07.787-01	1	54
2018-10-26 15:28:41.409-01	2018-10-26 15:28:41.409-01	1	55
2018-10-26 15:54:25.411-01	2018-10-26 15:54:25.411-01	1	56
2018-10-26 15:59:27.417-01	2018-10-26 15:59:27.417-01	1	57
2018-10-26 16:03:11.264-01	2018-10-26 16:03:11.264-01	1	58
2018-10-26 16:07:05.372-01	2018-10-26 16:07:05.372-01	1	59
2018-10-26 16:15:50.574-01	2018-10-26 16:15:50.574-01	1	60
2018-10-26 16:39:02.848-01	2018-10-26 16:39:02.848-01	1	61
2018-10-26 17:45:49.715-01	2018-10-26 17:45:49.715-01	1	62
2018-10-29 14:45:30.451-01	2018-10-29 14:45:30.451-01	1	64
2018-10-29 16:14:30.113-01	2018-10-29 16:14:30.113-01	1	65
2018-10-29 16:46:45.408-01	2018-10-29 16:46:45.408-01	1	66
2018-10-29 16:46:45.408-01	2018-10-29 16:46:45.408-01	2	66
2018-10-29 16:48:39.438-01	2018-10-29 16:48:39.438-01	1	67
2018-10-29 16:51:01.628-01	2018-10-29 16:51:01.628-01	1	68
2018-10-29 16:51:01.628-01	2018-10-29 16:51:01.628-01	2	68
2018-10-29 16:52:26.892-01	2018-10-29 16:52:26.892-01	1	69
2018-10-30 08:56:47.22-01	2018-10-30 08:56:47.22-01	1	70
2018-10-30 08:59:50.726-01	2018-10-30 08:59:50.726-01	1	71
2018-10-30 09:02:13.913-01	2018-10-30 09:02:13.913-01	1	72
2018-10-30 09:04:24.049-01	2018-10-30 09:04:24.049-01	1	73
2018-10-30 09:05:50.431-01	2018-10-30 09:05:50.431-01	1	74
2018-10-30 09:08:25.086-01	2018-10-30 09:08:25.086-01	1	75
2018-10-30 09:11:23.876-01	2018-10-30 09:11:23.876-01	1	76
2018-10-30 09:11:23.876-01	2018-10-30 09:11:23.876-01	2	76
2018-10-30 09:13:38.049-01	2018-10-30 09:13:38.049-01	1	77
2018-10-30 09:13:38.049-01	2018-10-30 09:13:38.049-01	2	77
2018-10-30 09:15:39.843-01	2018-10-30 09:15:39.843-01	1	78
2018-10-30 09:15:39.843-01	2018-10-30 09:15:39.843-01	2	78
2018-10-30 09:18:22.973-01	2018-10-30 09:18:22.973-01	1	79
2018-10-30 09:20:08.742-01	2018-10-30 09:20:08.742-01	1	80
2018-10-30 09:29:54.46-01	2018-10-30 09:29:54.46-01	1	81
2018-10-30 09:29:54.46-01	2018-10-30 09:29:54.46-01	2	81
2018-10-30 09:38:25.19-01	2018-10-30 09:38:25.19-01	1	82
2018-10-30 09:45:56.039-01	2018-10-30 09:45:56.039-01	1	83
2018-10-30 09:45:56.039-01	2018-10-30 09:45:56.039-01	2	83
2018-10-30 09:49:02.031-01	2018-10-30 09:49:02.031-01	1	84
2018-10-30 09:52:09.483-01	2018-10-30 09:52:09.483-01	1	85
2018-10-30 09:54:42.122-01	2018-10-30 09:54:42.122-01	1	86
2018-10-30 10:14:50.72-01	2018-10-30 10:14:50.72-01	1	87
2018-10-30 10:53:24.028-01	2018-10-30 10:53:24.028-01	1	88
2018-10-30 10:59:13.739-01	2018-10-30 10:59:13.739-01	1	89
2018-10-30 10:59:13.739-01	2018-10-30 10:59:13.739-01	2	89
2018-10-30 11:02:38.354-01	2018-10-30 11:02:38.354-01	1	90
2018-10-30 11:02:38.354-01	2018-10-30 11:02:38.354-01	2	90
2018-10-30 11:05:19.675-01	2018-10-30 11:05:19.675-01	1	91
2018-10-30 11:05:19.675-01	2018-10-30 11:05:19.675-01	2	91
2018-10-30 11:11:30.888-01	2018-10-30 11:11:30.888-01	1	92
2018-10-30 11:11:30.888-01	2018-10-30 11:11:30.888-01	2	92
2018-10-30 11:20:14.439-01	2018-10-30 11:20:14.439-01	1	93
2018-10-30 11:20:14.439-01	2018-10-30 11:20:14.439-01	2	93
2018-10-30 11:24:20.648-01	2018-10-30 11:24:20.648-01	1	94
2018-10-30 11:29:45.088-01	2018-10-30 11:29:45.088-01	1	95
2018-10-30 11:33:12.585-01	2018-10-30 11:33:12.585-01	1	96
2018-10-30 11:37:38.044-01	2018-10-30 11:37:38.044-01	1	97
2018-10-30 11:37:38.044-01	2018-10-30 11:37:38.044-01	2	97
2018-10-30 11:40:32.281-01	2018-10-30 11:40:32.281-01	1	98
2018-10-30 11:40:32.281-01	2018-10-30 11:40:32.281-01	2	98
2018-10-30 11:44:47.207-01	2018-10-30 11:44:47.207-01	1	99
2018-10-30 11:44:47.207-01	2018-10-30 11:44:47.207-01	2	99
2018-10-30 11:48:07.408-01	2018-10-30 11:48:07.408-01	1	100
2018-10-30 11:48:07.408-01	2018-10-30 11:48:07.408-01	2	100
2018-10-30 12:02:15.93-01	2018-10-30 12:02:15.93-01	1	101
2018-10-30 12:08:24.801-01	2018-10-30 12:08:24.801-01	1	102
2018-10-30 12:08:24.801-01	2018-10-30 12:08:24.801-01	2	102
2018-10-30 12:17:28.98-01	2018-10-30 12:17:28.98-01	1	103
2018-10-30 12:19:28.879-01	2018-10-30 12:19:28.879-01	1	104
2018-10-30 12:22:29.197-01	2018-10-30 12:22:29.197-01	1	105
2018-10-30 12:24:52.071-01	2018-10-30 12:24:52.071-01	1	106
2018-10-30 12:28:22.857-01	2018-10-30 12:28:22.857-01	1	107
2018-10-30 12:31:13.78-01	2018-10-30 12:31:13.78-01	1	108
2018-10-30 12:31:13.78-01	2018-10-30 12:31:13.78-01	2	108
2018-10-30 12:36:58.541-01	2018-10-30 12:36:58.541-01	1	109
2018-10-30 12:42:52.178-01	2018-10-30 12:42:52.178-01	1	110
2018-10-30 12:42:52.178-01	2018-10-30 12:42:52.178-01	2	110
2018-10-30 12:48:09.705-01	2018-10-30 12:48:09.705-01	1	111
2018-10-30 12:48:09.705-01	2018-10-30 12:48:09.705-01	2	111
2018-10-30 13:08:40.092-01	2018-10-30 13:08:40.092-01	1	112
2018-10-30 13:08:40.092-01	2018-10-30 13:08:40.092-01	2	112
2018-10-30 13:14:39.028-01	2018-10-30 13:14:39.028-01	1	113
2018-10-30 13:14:39.028-01	2018-10-30 13:14:39.028-01	2	113
2018-10-30 13:18:52.079-01	2018-10-30 13:18:52.079-01	1	114
2018-10-30 13:23:42.422-01	2018-10-30 13:23:42.422-01	1	115
2018-10-30 13:23:42.422-01	2018-10-30 13:23:42.422-01	2	115
2018-10-30 15:37:42.94-01	2018-10-30 15:37:42.94-01	1	116
2018-10-30 17:22:03.64-01	2018-10-30 17:22:03.64-01	1	117
2018-10-30 17:25:54.268-01	2018-10-30 17:25:54.268-01	1	118
2018-10-30 17:28:50.975-01	2018-10-30 17:28:50.975-01	1	119
2018-10-30 17:32:32.456-01	2018-10-30 17:32:32.456-01	1	120
2018-10-30 17:37:22.242-01	2018-10-30 17:37:22.242-01	1	121
2018-10-31 11:44:54.942-01	2018-10-31 11:44:54.942-01	1	122
2018-10-31 11:44:54.942-01	2018-10-31 11:44:54.942-01	2	122
2018-10-31 12:57:01.824-01	2018-10-31 12:57:01.824-01	1	123
2018-10-31 12:57:01.824-01	2018-10-31 12:57:01.824-01	2	123
2018-10-31 13:06:10.597-01	2018-10-31 13:06:10.597-01	1	124
2018-10-31 14:49:14.924-01	2018-10-31 14:49:14.924-01	1	125
2018-10-31 14:58:33.045-01	2018-10-31 14:58:33.045-01	1	126
2018-10-31 15:03:22.698-01	2018-10-31 15:03:22.698-01	1	127
2018-10-31 15:03:22.698-01	2018-10-31 15:03:22.698-01	2	127
2018-10-31 15:08:03.641-01	2018-10-31 15:08:03.641-01	1	128
2018-10-31 15:35:55.903-01	2018-10-31 15:35:55.903-01	1	130
2018-10-31 16:30:32.122-01	2018-10-31 16:30:32.122-01	1	131
2018-10-31 16:37:50.23-01	2018-10-31 16:37:50.23-01	1	132
2018-10-31 16:41:56.611-01	2018-10-31 16:41:56.611-01	1	133
2018-10-31 16:41:56.611-01	2018-10-31 16:41:56.611-01	2	133
2018-10-31 16:47:47.595-01	2018-10-31 16:47:47.595-01	1	134
2018-10-31 16:47:47.595-01	2018-10-31 16:47:47.595-01	2	134
2018-10-31 16:56:05.337-01	2018-10-31 16:56:05.337-01	1	135
2018-10-31 17:24:55.336-01	2018-10-31 17:24:55.336-01	1	136
2018-10-31 17:27:54.017-01	2018-10-31 17:27:54.017-01	1	137
2018-10-31 17:35:55.069-01	2018-10-31 17:35:55.069-01	1	138
2018-10-31 17:41:27.073-01	2018-10-31 17:41:27.073-01	1	139
2018-11-02 15:19:41.251-01	2018-11-02 15:19:41.251-01	1	140
2018-11-02 15:58:05.846-01	2018-11-02 15:58:05.846-01	1	141
2018-11-02 16:04:33.313-01	2018-11-02 16:04:33.313-01	1	142
2018-11-05 09:23:09.318-01	2018-11-05 09:23:09.318-01	1	25
2018-11-05 09:33:52.07-01	2018-11-05 09:33:52.07-01	1	63
2018-11-05 09:50:40.997-01	2018-11-05 09:50:40.997-01	1	143
2018-11-05 11:04:22.063-01	2018-11-05 11:04:22.063-01	1	144
2018-11-05 12:03:18.192-01	2018-11-05 12:03:18.192-01	1	145
2018-11-06 10:34:26.042-01	2018-11-06 10:34:26.042-01	1	146
2018-11-06 12:35:52.043-01	2018-11-06 12:35:52.043-01	1	147
2018-11-06 15:44:30.591-01	2018-11-06 15:44:30.591-01	1	148
2018-11-06 15:44:30.591-01	2018-11-06 15:44:30.591-01	2	148
2018-11-08 12:19:44.04-01	2018-11-08 12:19:44.04-01	1	149
2018-11-08 12:19:44.04-01	2018-11-08 12:19:44.04-01	2	149
2018-11-08 12:40:01.568-01	2018-11-08 12:40:01.568-01	1	150
2018-11-09 09:40:47.189-01	2018-11-09 09:40:47.189-01	1	151
2018-11-09 10:25:06.057-01	2018-11-09 10:25:06.057-01	1	152
2018-11-12 10:39:38.475-01	2018-11-12 10:39:38.475-01	1	153
2018-11-12 17:26:01.539-01	2018-11-12 17:26:01.539-01	1	154
2018-11-13 10:34:46.13-01	2018-11-13 10:34:46.13-01	1	155
2018-11-13 10:50:00.982-01	2018-11-13 10:50:00.982-01	1	157
2018-11-13 10:55:07.411-01	2018-11-13 10:55:07.411-01	1	158
2018-11-13 10:59:41.61-01	2018-11-13 10:59:41.61-01	1	159
\.


--
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discounts (id, quantity, reason, "createdAt", "updatedAt", "personId", "userId") FROM stdin;
\.


--
-- Data for Name: evaluations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evaluations (id, shop, shift_from, shift_to, shop_number, date_from, date_to, cachier, cleaning, customer_service, replacement, team_work, cold_meats, flexibility, autonomy, punctuality, honesty, proactivity, responsability, interest_level, availability, personal_hygiene, obs, responsible_hr, advisor, "createdAt", "updatedAt", "personId", "userId") FROM stdin;
2	fazenda	14:00:00	18:00:00	1	2018-10-06	2018-10-12	3	4	3	4	3	4	3	3	4	3	4	4	4	4	4		Narciso	Janice	2018-10-30 16:31:21.228-01	2018-10-30 16:31:21.228-01	77	2
3	achada	06:00:00	10:00:00	2	2018-07-18	2018-07-24	4	5	5	4	5	5	4	4	5	4	4	5	5	5	5	De acordo com a minha observação sobre ela e uma excelente pessoa trabalha bem sabes conversar com os clientes, convencer os clientes, respeita as regras de trabalho para mim e um dos melhores estagiada que trabalha aqui na loja de asa. obrigado	Narciso	Adérito	2018-10-31 12:45:16.073-01	2018-10-31 12:45:16.073-01	122	2
4	fazenda	10:00:00	14:00:00	1	2018-08-01	2018-08-07	3	4	4	4	3	4	4	3	5	3	3	3	5	4	5		Narciso	Janice	2018-10-31 12:54:02.132-01	2018-10-31 12:54:02.132-01	122	2
5	achada	06:00:00	10:00:00	2	2018-07-25	2018-07-31	4	5	5	4	5	5	4	4	5	4	4	5	5	5	5	ela e dedicada, mostra muito desempenho e interesse na trabalha com a nossa equipa	Narciso	Adérito	2018-10-31 13:02:57.95-01	2018-10-31 13:02:57.95-01	123	2
6	s_domingos	14:00:00	18:00:00	3	2018-08-30	2018-09-05	4	5	5	5	5	5	4	4	5	5	5	4	5	4	5	Chega sempre mais cedo mostra sempre disponível para qualquer trabalho muito ativa 	Narciso Afonso	Cleida Moreno	2018-10-31 13:20:26.252-01	2018-10-31 13:20:26.252-01	124	2
7	achada	14:00:00	18:00:00	2	2018-09-20	2018-09-26	4	4	5	4	4	4	4	4	5	4	4	4	5	5	5	Ela faz óptimo trabalho ,no atendimento ,na charcutaria e na caixa.	Narciso Afonso	Adérito Silva	2018-10-31 13:28:32.148-01	2018-10-31 13:28:32.148-01	124	2
8	achada	18:00:00	22:00:00	2	2018-08-18	2018-08-24	4	4	5	4	5	4	4	4	5	4	4	4	5	5	5	de acordo com a minha observação ela foi uma boa estagiaria sabe trabalhar em equipa, respeita a nossa regra, sabe conversar com clientes, trata clientes com todo respeito. ela sabe vender mesmo. obrigado	Narciso Afonso	Adérito Silva	2018-10-31 13:36:10.17-01	2018-10-31 13:36:10.17-01	52	2
9	fazenda	14:00:00	18:00:00	1	2018-09-25	2018-10-01	3	3	3	3	3	3	3	3	3	3	3	3	4	3	3		Narciso Afonso	Julio César	2018-10-31 13:40:25.392-01	2018-10-31 13:40:25.392-01	52	2
10	fazenda	06:00:00	10:00:00	1	2018-09-01	2018-09-07	3	3	3	3	3	3	3	3	3	3	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-10-31 13:49:41.239-01	2018-10-31 13:49:41.239-01	51	2
11	achada	14:00:00	18:00:00	2	2018-09-15	2018-09-21	5	4	4	3	4	4	4	4	5	4	4	4	5	4	5	resumindo e concluindo ela e mesmo bom	Narciso Afonso	Adérito Silva	2018-10-31 13:55:11.028-01	2018-10-31 13:55:11.028-01	51	2
28	achada	18:00:00	22:00:00	2	2018-08-27	2018-09-02	3	4	3	3	4	4	4	3	5	4	3	3	4	4	5		Narciso Afonso	Adérito Silva	2018-11-02 09:43:13.443-01	2018-11-02 09:43:13.443-01	70	2
29	fazenda	06:00:00	10:00:00	1	2018-10-01	2018-10-07	3	4	3	4	3	4	3	3	4	3	4	3	4	4	4		Narciso Afonso	Janice Semedo	2018-11-02 09:50:14.336-01	2018-11-02 09:50:14.336-01	80	2
30	fazenda	14:00:00	18:00:00	1	2018-09-25	2018-10-01	4	4	4	4	4	3	3	4	4	4	4	4	4	4	4		Narciso Afonso	Julio César	2018-11-02 09:55:02.476-01	2018-11-02 09:55:02.476-01	28	2
31	achada	18:00:00	22:00:00	2	2018-10-13	2018-10-19	4	5	5	4	4	5	4	4	5	5	5	4	5	4	5		Narciso Afonso	Wilson Oliveira	2018-11-02 09:57:48.629-01	2018-11-02 09:57:48.629-01	28	2
32	achada	10:00:00	14:00:00	2	2018-09-15	2018-09-21	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 09:14:26.052-01	2018-11-05 09:14:26.052-01	66	2
1	Achada	16:00:00	20:00:00	2	2018-10-05	2018-10-11	3	4	4	4	4	5	4	4	4	4	4	4	4	4	5	ELA FAZ UM BOM TRABALHO, TEM UM EXCELENTE ATENDIMENTO E PONTUAL.	Narciso Afonso	Adérito Silva	2018-10-30 10:42:42.96-01	2018-10-31 14:04:02.477-01	78	2
12	fazenda	10:00:00	14:00:00	1	2018-09-18	2018-09-24	3	4	3	4	4	3	3	3	4	3	3	3	4	4	4		Narciso Afonso	Janice Semedo	2018-10-31 14:17:54.723-01	2018-10-31 14:17:54.723-01	117	2
13	s_domingos	18:00:00	22:00:00	3	2018-09-25	2018-10-01	4	5	5	4	5	5	4	5	5	5	4	5	5	5	5	ela faz um excelente trabalho.	Narciso Afonso	Wilson Oliveira	2018-10-31 14:21:25.098-01	2018-10-31 14:21:25.098-01	117	2
14	achada	10:00:00	14:00:00	2	2018-10-02	2018-10-08	3	4	4	4	4	5	4	4	5	4	4	4	5	5	5		Narciso Afonso	Adérito Silva	2018-10-31 14:25:42.234-01	2018-10-31 14:25:42.234-01	117	2
15	achada	14:00:00	18:00:00	2	2018-09-18	2018-09-24	3	4	4	4	4	4	5	4	5	4	4	4	4	4	5	ela mostra muito desempenho, e trabalha razoável.	Narciso Afonso	Adérito Silva	2018-10-31 14:32:43.028-01	2018-10-31 14:32:43.028-01	54	2
16	s_domingos	06:00:00	10:00:00	3	2018-09-22	2018-09-28	3	4	4	3	4	4	4	3	5	3	3	4	5	4	5		Narciso Afonso	Catia Vieira	2018-10-31 14:35:27.683-01	2018-10-31 14:35:27.683-01	54	2
17	fazenda	10:00:00	14:00:00	1	2018-09-29	2018-10-05	3	3	3	4	3	4	3	3	3	3	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-10-31 14:45:23.296-01	2018-10-31 14:45:23.296-01	54	2
18	achada	14:00:00	18:00:00	2	2018-08-27	2018-09-02	3	5	4	4	4	5	4	3	5	4	4	4	4	4	5		Narciso Afonso	Adérito Silva	2018-10-31 17:53:44.12-01	2018-10-31 17:53:44.12-01	136	2
19	fazenda	14:00:00	18:00:00	1	2018-09-12	2018-09-18	3	4	3	3	4	4	3	3	4	3	3	4	4	3	3		Narciso Afonso	Júlio Cesar	2018-10-31 17:57:06.747-01	2018-10-31 17:57:06.747-01	136	2
20	fazenda	10:00:00	14:00:00	1	2018-09-18	2018-09-24	3	4	4	3	3	3	3	3	4	4	4	3	4	3	4		Narciso Afonso	Janice Semedo	2018-10-31 18:04:39.038-01	2018-10-31 18:04:39.038-01	56	2
21	achada	10:00:00	14:00:00	2	2018-09-24	2018-09-30	5	4	4	4	4	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-10-31 18:07:08.926-01	2018-10-31 18:07:08.926-01	56	2
22	s_domingos	08:00:00	12:00:00	3	2018-10-24	2018-10-30	4	3	3	3	4	3	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-10-31 18:14:52.972-01	2018-10-31 18:14:52.972-01	68	2
23	achada	18:00:00	22:00:00	2	2018-09-18	2018-09-24	3	4	4	5	4	3	4	4	4	4	4	4	4	4	5		Narciso Afonso	Adérito Silva	2018-11-02 08:52:26.056-01	2018-11-02 08:52:26.056-01	116	2
24	s_domingos	06:00:00	10:00:00	3	2018-09-03	2018-09-09	4	4	4	5	5	5	5	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-02 08:55:54.073-01	2018-11-02 08:55:54.073-01	116	2
25	s_domingos	14:00:00	18:00:00	3	2018-09-10	2018-09-16	3	5	5	4	5	5	4	5	5	5	4	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-02 09:00:01.015-01	2018-11-02 09:00:01.015-01	116	2
26	achada	06:00:00	10:00:00	2	2018-08-29	2018-10-04	3	4	4	4	4	4	4	3	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-02 09:23:01.983-01	2018-11-02 09:23:01.983-01	137	2
27	achada	14:00:00	18:00:00	2	2018-10-11	2018-10-17	3	4	3	4	4	4	4	4	4	4	4	4	4	4	5		Narciso Afonso	Adérito Silva	2018-11-02 09:30:21.15-01	2018-11-02 09:30:21.15-01	120	2
33	achada	14:00:00	18:00:00	2	2018-10-25	2018-10-31	4	5	5	5	5	5	4	5	5	5	4	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 10:17:42.931-01	2018-11-05 10:17:42.931-01	66	2
34	achada	06:00:00	10:00:00	2	2018-09-01	2018-09-05	4	4	4	4	4	4	3	3	4	4	4	4	4	3	4		Narciso Afonso	Adilson Mendes	2018-11-05 10:24:23.663-01	2018-11-05 10:24:23.663-01	141	2
35	achada	10:00:00	14:00:00	2	2018-09-16	2018-09-22	5	4	4	4	4	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 10:43:49.675-01	2018-11-05 10:43:49.675-01	48	2
36	achada	10:00:00	14:00:00	2	2018-09-16	2018-09-22	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 10:46:31.991-01	2018-11-05 10:46:31.991-01	49	2
37	achada	06:00:00	10:00:00	2	2018-09-25	2018-10-01	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 10:48:59.38-01	2018-11-05 10:48:59.38-01	60	2
38	achada	06:00:00	10:00:00	2	2018-09-25	2018-10-01	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 11:17:38.69-01	2018-11-05 11:17:38.69-01	57	2
39	achada	10:00:00	14:00:00	2	2018-09-15	2018-09-21	3	4	3	4	4	5	4	4	5	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 11:20:22.566-01	2018-11-05 11:20:22.566-01	53	2
40	achada	10:00:00	14:00:00	2	2018-08-08	2018-08-14	3	4	4	4	4	4	4	3	4	4	3	4	3	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 11:22:47.938-01	2018-11-05 11:22:47.938-01	134	2
41	achada	06:00:00	10:00:00	2	2018-09-09	2018-09-15	4	4	3	4	4	4	4	3	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 11:25:34.602-01	2018-11-05 11:25:34.602-01	128	2
42	achada	10:00:00	14:00:00	2	2018-08-05	2018-08-11	3	4	3	4	4	4	4	3	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 11:31:22.033-01	2018-11-05 11:31:22.033-01	132	2
43	s_domingos	18:00:00	22:00:00	3	2018-10-02	2018-10-08	2	2	2	3	1	3	2	2	3	3	3	2	2	2	3		Narciso Afonso	Catia Vieira	2018-11-05 11:37:36.484-01	2018-11-05 11:37:36.484-01	50	2
44	s_domingos	14:00:00	18:00:00	3	2018-10-06	2018-10-12	3	4	4	4	4	4	4	4	4	4	3	4	4	4	5		Narciso Afonso	Catia Vieira	2018-11-05 11:41:20.678-01	2018-11-05 11:41:20.678-01	119	2
45	s_domingos	10:00:00	14:00:00	3	2018-09-07	2018-09-13	4	3	4	4	5	5	5	4	5	5	5	5	5	5	5		Narciso Afonso	Cleida Moreno	2018-11-05 11:43:31.516-01	2018-11-05 11:43:31.516-01	49	2
46	s_domingos	14:00:00	18:00:00	3	2018-08-04	2018-08-10	4	4	3	3	4	4	4	3	3	3	3	4	4	5	4		Narciso Afonso	Adilson Mendes	2018-11-05 11:48:01.531-01	2018-11-05 11:48:01.531-01	135	2
47	fazenda	06:00:00	10:00:00	1	2018-10-01	2018-10-07	2	4	3	3	4	4	3	3	4	3	3	3	4	4	4		Narciso Afonso	Janice Semedo	2018-11-05 11:51:33.581-01	2018-11-05 11:51:33.581-01	26	2
48	fazenda	06:00:00	10:00:00	1	2018-08-20	2018-08-26	3	4	3	4	3	4	4	3	4	3	3	3	4	4	4		Narciso Afonso	Janice Semedo	2018-11-05 11:58:43.949-01	2018-11-05 11:58:43.949-01	131	2
49	fazenda	06:00:00	10:00:00	1	2018-09-19	2018-09-25	3	4	3	3	3	4	3	3	4	3	3	3	4	4	4		Narciso Afonso	Janice Semedo	2018-11-05 12:07:04.995-01	2018-11-05 12:07:04.995-01	59	2
50	fazenda	10:00:00	14:00:00	1	2018-08-29	2018-09-04	3	4	4	3	3	4	3	3	4	3	3	3	4	4	4		Narciso Afonso	Janice Semedo	2018-11-05 12:33:56.044-01	2018-11-05 12:33:56.044-01	58	2
51	fazenda	10:00:00	14:00:00	1	2018-09-09	2018-09-15	3	4	3	4	3	4	3	2	4	3	3	2	3	3	4		Narciso Afonso	Janice Semedo	2018-11-05 12:36:30.531-01	2018-11-05 12:36:30.531-01	139	2
52	fazenda	06:00:00	10:00:00	1	2018-10-01	2018-10-07	3	4	3	4	3	4	4	3	4	3	3	3	4	4	4		Narciso Afonso	Janice Semedo	2018-11-05 12:41:23.244-01	2018-11-05 12:41:23.244-01	120	2
53	fazenda	10:00:00	14:00:00	1	2018-09-19	2018-09-25	3	4	4	3	3	4	4	3	4	4	4	3	4	4	4		Narciso Afonso	Janice Semedo	2018-11-05 12:43:42.429-01	2018-11-05 12:43:42.429-01	118	2
54	fazenda	10:00:00	14:00:00	1	2018-09-25	2018-10-01	3	3	3	3	3	3	3	3	3	3	2	3	2	3	3		Narciso Afonso	Julio César	2018-11-05 12:46:29.381-01	2018-11-05 12:46:29.381-01	130	2
55	s_domingos	06:00:00	10:00:00	3	2018-09-07	2018-09-13	4	5	5	5	5	5	4	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 12:54:07.584-01	2018-11-05 12:54:07.584-01	141	2
56	s_domingos	06:00:00	10:00:00	3	2018-09-02	2018-09-08	4	5	5	5	5	5	4	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 12:58:31.137-01	2018-11-05 12:58:31.137-01	138	2
57	achada	10:00:00	14:00:00	2	2018-10-13	2018-10-19	3	5	4	4	5	5	4	5	5	5	4	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 13:01:07.524-01	2018-11-05 13:01:07.524-01	26	2
58	achada	06:00:00	10:00:00	2	2018-09-23	2018-10-29	4	5	4	5	5	5	5	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 15:32:35.249-01	2018-11-05 15:32:35.249-01	76	2
59	s_domingos	06:00:00	10:00:00	3	2018-08-10	2018-08-16	4	5	5	5	5	5	5	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 15:37:53.017-01	2018-11-05 15:37:53.017-01	135	2
60	achada	18:00:00	22:00:00	2	2018-10-13	2018-10-19	4	5	5	5	5	5	5	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 15:40:18.193-01	2018-11-05 15:40:18.193-01	119	2
61	s_domingos	06:00:00	10:00:00	3	2018-10-22	2018-10-28	4	5	5	5	4	5	5	5	5	5	4	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 15:42:39.641-01	2018-11-05 15:42:39.641-01	128	2
62	achada	10:00:00	14:00:00	2	2018-10-13	2018-10-19	4	5	4	4	5	5	5	4	5	5	4	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 15:45:22.4-01	2018-11-05 15:45:22.4-01	29	2
63	achada	18:00:00	22:00:00	2	2018-10-13	2018-10-19	4	5	4	4	5	5	4	5	5	5	4	4	5	4	5		Narciso Afonso	Wilson Oliveira	2018-11-05 15:47:20.059-01	2018-11-05 15:47:20.059-01	118	2
64	fazenda	06:00:00	10:00:00	1	2018-10-24	2018-10-30	2	3	4	3	4	4	3	3	3	3	3	3	3	3	5		Narciso Afonso	Janice Semedo	2018-11-05 15:49:16.784-01	2018-11-05 15:49:16.784-01	53	2
65	fazenda	06:00:00	10:00:00	1	2018-10-24	2018-10-30	2	3	3	3	3	3	3	2	3	3	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-05 15:51:17.927-01	2018-11-05 15:51:17.927-01	50	2
66	fazenda	10:00:00	14:00:00	1	2018-10-24	2018-10-30	4	3	3	3	3	4	4	3	3	3	3	4	4	3	3		Narciso Afonso	Julio César	2018-11-05 15:53:04.318-01	2018-11-05 15:53:04.318-01	49	2
67	achada	10:00:00	14:00:00	2	2018-10-25	2018-10-31	4	5	5	5	5	5	5	4	5	5	4	5	4	4	5		Narciso Afonso	Wilson Oliveira	2018-11-05 16:01:40.863-01	2018-11-05 16:01:40.863-01	69	2
68	achada	10:00:00	14:00:00	2	2018-10-25	2018-10-31	4	5	5	5	5	5	4	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-05 16:06:29.633-01	2018-11-05 16:06:29.633-01	17	2
69	s_domingos	06:00:00	10:00:00	3	2018-10-28	2018-11-03	4	4	4	4	4	4	4	3	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 16:22:58.515-01	2018-11-05 16:22:58.515-01	76	2
70	s_domingos	06:00:00	10:00:00	3	2018-10-28	2018-11-03	4	4	5	4	4	3	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 16:25:59.341-01	2018-11-05 16:25:59.341-01	72	2
71	s_domingos	06:00:00	10:00:00	3	2018-10-28	2018-11-03	3	5	4	4	4	5	4	4	5	4	3	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-05 16:38:45.393-01	2018-11-05 16:38:45.393-01	36	2
72	fazenda	06:00:00	10:00:00	1	2018-10-25	2018-10-31	3	3	3	3	3	3	3	3	4	3	4	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-05 16:42:23.606-01	2018-11-05 16:42:23.606-01	38	2
73	fazenda	06:00:00	10:00:00	1	2018-10-27	2018-11-02	3	4	4	3	4	3	3	3	4	3	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-05 16:47:22.753-01	2018-11-05 16:47:22.753-01	74	2
74	fazenda	18:00:00	22:00:00	1	2018-10-23	2018-10-29	3	3	4	4	4	3	4	3	4	3	3	4	3	4	3		Narciso Afonso	Julio César	2018-11-05 16:51:24.311-01	2018-11-05 16:51:24.311-01	35	2
75	achada	10:00:00	14:00:00	2	2018-10-20	2018-09-26	3	4	4	4	4	4	4	4	5	4	4	4	4	4	5		Narciso Afonso	Adérito Silva	2018-11-05 17:01:30.787-01	2018-11-05 17:01:30.787-01	55	2
76	s_domingos	14:00:00	22:00:00	3	2018-08-18	2018-08-18	1	4	5	5	5	4	5	5	5	5	5	5	5	5	5	Não faz caixa porque é o chefe de armazém	Narciso Afonso	Cleida Moreno	2018-11-06 12:26:17.376-01	2018-11-06 12:26:17.376-01	101	2
77	s_domingos	14:00:00	22:00:00	3	2018-08-18	2018-08-18	4	5	5	4	5	5	5	4	5	5	4	5	4	5	5		Narciso Afonso	Cleida Moreno	2018-11-06 12:30:06.159-01	2018-11-06 12:30:06.159-01	85	2
78	fazenda	06:00:00	14:00:00	1	2018-08-19	2018-08-19	4	3	3	4	3	4	3	3	5	4	3	4	3	3	4		Narciso Afonso	Janice Semedo	2018-11-07 15:36:28.806-01	2018-11-07 15:36:28.806-01	110	2
79	fazenda	06:00:00	14:00:00	1	2018-08-19	2018-08-19	4	4	4	4	4	4	3	4	4	4	4	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-07 15:38:52.205-01	2018-11-07 15:38:52.205-01	109	2
80	fazenda	06:00:00	14:00:00	1	2018-08-19	2018-08-19	4	5	5	5	5	4	4	4	4	4	5	5	4	4	5		Narciso Afonso	Janice Semedo	2018-11-07 15:43:09.594-01	2018-11-07 15:43:09.594-01	108	2
81	achada	06:00:00	14:00:00	2	2018-08-19	2018-08-19	4	4	3	3	4	3	4	3	4	4	4	3	4	4	4	Fala com clientes na caixa	Narciso Afonso	Adilson Mendes	2018-11-07 16:26:52.112-01	2018-11-07 16:26:52.112-01	111	2
82	achada	06:00:00	14:00:00	2	2018-08-19	2018-08-19	3	4	4	4	4	4	4	4	4	4	4	4	4	4	4	Arruma a loja e armazém	Narciso Afonso	Adilson Mendes	2018-11-07 16:31:13.186-01	2018-11-07 16:31:13.186-01	88	2
83	achada	06:00:00	14:00:00	2	2018-08-19	2018-08-19	4	4	4	4	4	3	4	4	4	4	4	4	4	4	4	Sempre fala com clientes para levar produtos	Narciso Afonso	Adilson Mendes	2018-11-07 16:35:33.287-01	2018-11-07 16:35:33.287-01	89	2
84	achada	06:00:00	14:00:00	2	2018-08-19	2018-08-19	4	4	5	4	5	5	4	4	5	4	4	4	4	4	5	Faz um excelente trabalho	Narciso Afonso	Adérito Silva	2018-11-07 16:37:59.643-01	2018-11-07 16:37:59.643-01	114	2
85	achada	06:00:00	14:00:00	2	2018-08-19	2018-08-19	5	4	5	4	5	4	4	4	4	5	5	4	4	5	5		Narciso Afonso	Adérito Silva	2018-11-07 16:39:22.996-01	2018-11-07 16:39:22.996-01	92	2
86	achada	06:00:00	14:00:00	2	2018-08-19	2018-08-19	4	5	5	4	5	5	4	4	5	4	4	4	4	4	5		Narciso Afonso	Adérito Silva	2018-11-07 16:41:16.545-01	2018-11-07 16:41:16.545-01	112	2
87	fazenda	06:00:00	10:00:00	1	2018-08-24	2018-08-24	4	4	4	4	4	5	3	4	5	4	4	4	4	4	5		Narciso Afonso	Janice Semedo	2018-11-07 16:43:12.693-01	2018-11-07 16:43:12.693-01	110	2
88	fazenda	06:00:00	14:00:00	1	2018-08-24	2018-08-24	4	4	5	5	4	4	4	4	4	4	4	4	3	4	4		Narciso Afonso	Janice Semedo	2018-11-07 16:45:06.544-01	2018-11-07 16:45:06.544-01	108	2
89	fazenda	10:00:00	22:00:00	1	2018-08-24	2018-08-24	4	5	5	5	4	3	5	3	4	4	4	4	4	4	5		Narciso Afonso	Emanuel Cabral	2018-11-07 16:47:28.689-01	2018-11-07 16:47:28.689-01	97	2
90	achada	06:00:00	10:00:00	2	2018-08-24	2018-08-24	4	4	5	5	5	5	4	4	5	4	4	4	4	4	5		Narciso Afonso	Adérito Silva	2018-11-07 16:49:35.303-01	2018-11-07 16:49:35.303-01	114	2
91	fazenda	14:00:00	22:00:00	1	2018-08-24	2018-08-24	3	4	4	4	4	3	3	3	4	4	4	4	3	3	4		Narciso Afonso	Julio César	2018-11-07 16:51:38.749-01	2018-11-07 16:51:38.749-01	115	2
92	fazenda	14:00:00	22:00:00	1	2018-08-24	2018-08-24	4	4	4	3	3	4	3	4	4	3	4	4	4	3	4		Narciso Afonso	Julio César	2018-11-07 16:56:18.492-01	2018-11-07 16:56:18.492-01	113	2
93	achada	06:00:00	14:00:00	2	2018-08-24	2018-08-24	5	4	5	4	5	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Julio César	2018-11-07 16:59:53.079-01	2018-11-07 16:59:53.079-01	92	2
94	achada	14:00:00	22:00:00	2	2018-08-24	2018-08-24	5	5	5	4	5	5	4	4	5	4	4	4	4	4	5		Narciso Afonso	Julio César	2018-11-07 17:03:12.373-01	2018-11-07 17:03:12.373-01	112	2
95	s_domingos	14:00:00	22:00:00	3	2018-08-24	2018-08-24	1	4	5	5	5	3	5	5	5	5	5	5	5	5	5		Narciso Afonso	Cleida Moreno	2018-11-07 17:07:22.034-01	2018-11-07 17:07:22.034-01	101	2
96	s_domingos	14:00:00	22:00:00	3	2018-08-24	2018-08-24	4	3	4	4	5	5	4	4	4	5	5	4	4	5	5		Narciso Afonso	Cleida Moreno	2018-11-07 17:09:17.378-01	2018-11-07 17:09:17.378-01	85	2
97	achada	14:00:00	22:00:00	2	2018-08-24	2018-08-24	4	3	3	3	2	3	4	4	3	3	3	3	4	4	5		Narciso Afonso	Emanuel Cabral	2018-11-07 17:12:47.225-01	2018-11-07 17:12:47.225-01	98	2
98	achada	14:00:00	22:00:00	2	2018-08-24	2018-08-24	4	4	5	4	3	5	5	3	4	4	4	4	3	4	5		Narciso Afonso	Emanuel Cabral	2018-11-07 17:14:28.379-01	2018-11-07 17:14:28.379-01	90	2
99	s_domingos	14:00:00	22:00:00	3	2018-08-25	2018-08-25	4	4	3	5	3	3	5	4	5	4	3	4	3	4	5		Narciso Afonso	Emanuel Cabral	2018-11-07 17:16:50.573-01	2018-11-07 17:16:50.573-01	91	2
100	fazenda	06:00:00	14:00:00	1	2018-08-25	2018-08-25	4	4	3	3	3	4	3	4	5	3	3	4	4	4	4		Narciso Afonso	Emanuel Cabral	2018-11-07 17:18:46.665-01	2018-11-07 17:18:46.665-01	102	2
101	fazenda	06:00:00	14:00:00	1	2018-08-26	2018-08-25	4	4	3	4	4	4	4	4	4	4	4	4	3	4	4		Narciso Afonso	Janice Semedo	2018-11-07 17:21:32.424-01	2018-11-07 17:21:32.424-01	109	2
102	fazenda	14:00:00	22:00:00	1	2018-08-24	2018-08-24	4	4	5	5	4	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Janice Semedo	2018-11-07 17:23:21.958-01	2018-11-07 17:23:21.958-01	115	2
103	fazenda	06:00:00	14:00:00	1	2018-09-01	2018-09-01	4	4	4	3	4	5	3	3	4	4	4	3	3	4	5		Narciso Afonso	Janice Semedo	2018-11-07 17:26:26.136-01	2018-11-07 17:26:26.136-01	110	2
104	fazenda	14:00:00	22:00:00	1	2018-09-01	2018-09-01	3	4	4	3	3	4	3	4	4	4	3	3	3	3	5		Narciso Afonso	Julio César	2018-11-07 17:31:09.399-01	2018-11-07 17:31:09.399-01	113	2
105	fazenda	14:00:00	22:00:00	1	2018-09-01	2018-09-01	4	4	4	3	4	4	4	3	3	4	4	4	3	4	4		Narciso Afonso	Janice Semedo	2018-11-07 17:33:52.821-01	2018-11-07 17:33:52.821-01	109	2
107	fazenda	14:00:00	22:00:00	1	2018-09-01	2018-09-01	3	4	4	4	4	3	4	3	4	3	4	3	3	3	3		Narciso Afonso	Julio César	2018-11-07 17:39:34.838-01	2018-11-07 17:39:34.838-01	115	2
108	fazenda	06:00:00	14:00:00	1	2018-09-01	2018-09-01	4	3	5	4	4	4	4	4	4	4	4	4	3	4	4		Narciso Afonso	Janice Semedo	2018-11-07 17:41:21.245-01	2018-11-07 17:41:21.245-01	108	2
109	fazenda	06:00:00	14:00:00	1	2018-09-01	2018-09-01	3	4	4	5	4	4	4	4	4	4	3	4	3	3	5		Narciso Afonso	Janice Semedo	2018-11-07 17:43:38.472-01	2018-11-07 17:43:38.472-01	108	2
110	fazenda	06:00:00	14:00:00	1	2018-09-01	2018-09-01	4	4	4	3	4	4	4	3	3	4	4	4	4	4	4		Narciso Afonso	Janice Semedo	2018-11-07 17:46:39.239-01	2018-11-07 17:46:39.239-01	110	2
111	s_domingos	14:00:00	18:00:00	3	2018-09-01	2018-09-01	4	4	5	4	5	4	4	4	4	4	4	4	4	4	5		Narciso Afonso	Cleida Moreno	2018-11-07 17:48:34.946-01	2018-11-07 17:48:34.946-01	85	2
112	fazenda	14:00:00	22:00:00	1	2018-09-01	2018-09-01	4	3	3	3	3	4	3	3	4	3	3	4	3	3	4		Narciso Afonso	Janice Semedo	2018-11-07 17:55:01.318-01	2018-11-07 17:55:01.318-01	110	2
113	fazenda	14:00:00	22:00:00	1	2018-09-15	2018-09-15	3	4	4	4	4	3	3	4	4	3	4	4	3	3	4		Narciso Afonso	Janice Semedo	2018-11-07 17:59:07.99-01	2018-11-07 17:59:07.99-01	115	2
114	fazenda	14:00:00	22:00:00	1	2018-09-15	2018-09-15	3	3	4	4	4	3	4	3	4	3	3	4	3	4	5		Narciso Afonso	Janice Semedo	2018-11-07 18:04:34.393-01	2018-11-07 18:04:34.393-01	108	2
115	fazenda	06:00:00	14:00:00	1	2018-09-15	2018-09-15	4	4	3	3	3	4	3	3	4	3	4	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-09 10:30:26.072-01	2018-11-09 10:30:26.072-01	109	2
116	fazenda	14:00:00	22:00:00	1	2018-09-15	2018-09-15	3	3	4	4	4	4	3	3	4	4	3	3	3	3	3		Narciso Afonso	Julio César	2018-11-10 10:36:18.58-01	2018-11-10 10:36:18.58-01	115	2
117	fazenda	14:00:00	22:00:00	1	2018-09-15	2018-09-15	3	3	4	3	3	3	3	3	4	4	3	4	3	3	3		Narciso Afonso	Julio César	2018-11-10 10:37:57.718-01	2018-11-10 10:37:57.718-01	108	2
118	fazenda	14:00:00	22:00:00	1	2018-09-15	2018-09-15	3	4	4	3	3	4	3	3	3	3	3	3	3	3	3		Narciso Afonso	Julio César	2018-11-10 10:40:22.899-01	2018-11-10 10:40:22.899-01	113	2
119	s_domingos	06:00:00	14:00:00	3	2018-09-16	2018-09-16	1	5	5	5	5	4	4	5	5	5	5	5	5	4	5	Ele não tem caixa, porque é o chefe do armazém.	Narciso Afonso	Wilson Oliveira	2018-11-10 10:44:20.149-01	2018-11-10 10:44:20.149-01	107	2
120	s_domingos	06:00:00	14:00:00	3	2018-09-16	2018-09-16	1	4	5	5	5	3	5	5	4	5	5	5	5	5	5	Não tem caixa, porque é o chefe do armazém.	Narciso Afonso	Cleida Moreno	2018-11-10 10:46:45.133-01	2018-11-10 10:46:45.133-01	101	2
121	s_domingos	14:00:00	22:00:00	3	2018-09-22	2018-09-22	4	5	5	4	4	4	3	4	3	3	4	4	4	3	5	Muito distraída na caixa	Narciso Afonso	Cleida Moreno	2018-11-10 10:49:34.449-01	2018-11-10 10:49:34.449-01	85	2
122	fazenda	06:00:00	14:00:00	1	2018-09-25	2018-09-25	4	3	3	3	4	4	3	3	4	4	4	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 10:52:52.71-01	2018-11-10 10:52:52.71-01	110	2
123	fazenda	06:00:00	14:00:00	1	2018-09-23	2018-09-23	4	4	3	3	4	4	3	3	4	3	4	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 10:55:22.677-01	2018-11-10 10:55:22.677-01	109	2
124	fazenda	06:00:00	14:00:00	1	2018-09-23	2018-09-23	3	4	4	4	4	3	3	4	4	4	4	3	4	3	4		Narciso Afonso	Janice Semedo	2018-11-10 10:57:39.976-01	2018-11-10 10:57:39.976-01	115	2
125	fazenda	06:00:00	14:00:00	1	2018-09-23	2018-09-23	4	4	5	4	4	4	4	4	4	4	3	4	3	4	4		Narciso Afonso	Janice Semedo	2018-11-10 10:59:53.96-01	2018-11-10 10:59:53.96-01	108	2
126	achada	06:00:00	14:00:00	2	2018-10-13	2018-10-13	4	5	4	5	5	5	5	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-10 11:02:31.656-01	2018-11-10 11:02:31.656-01	114	2
127	achada	06:00:00	14:00:00	2	2018-10-13	2018-10-13	5	5	5	5	5	5	5	4	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-10 11:05:20.166-01	2018-11-10 11:05:20.166-01	112	2
128	fazenda	14:00:00	22:00:00	1	2018-10-30	2018-10-30	3	3	4	2	3	4	3	3	3	3	3	2	3	3	4		Narciso Afonso	Julio César	2018-11-10 11:10:15.245-01	2018-11-10 11:10:15.245-01	113	2
129	fazenda	14:00:00	22:00:00	1	2018-10-30	2018-10-30	3	4	3	4	4	3	4	4	4	4	4	4	4	4	3		Narciso Afonso	Julio César	2018-11-10 11:11:46.262-01	2018-11-10 11:11:46.262-01	115	2
130	fazenda	06:00:00	14:00:00	1	2018-10-30	2018-10-30	3	2	4	3	3	2	2	3	3	3	2	3	3	2	2	Trabalhava bem	Narciso Afonso	Julio César	2018-11-10 11:14:10.46-01	2018-11-10 11:14:10.46-01	108	2
131	fazenda	14:00:00	22:00:00	1	2018-10-30	2018-10-30	2	4	4	3	3	4	3	3	3	4	3	3	3	3	3		Narciso Afonso	Julio César	2018-11-10 11:15:50.468-01	2018-11-10 11:15:50.468-01	106	2
132	fazenda	06:00:00	14:00:00	1	2018-10-31	2018-10-31	5	4	4	3	4	3	3	3	4	4	4	3	4	3	4		Narciso Afonso	Janice Semedo	2018-11-10 11:17:30.786-01	2018-11-10 11:17:30.786-01	110	2
133	fazenda	06:00:00	14:00:00	1	2018-10-31	2018-10-31	3	4	4	4	4	4	4	3	4	4	3	3	3	4	4		Narciso Afonso	Janice Semedo	2018-11-10 11:19:05.416-01	2018-11-10 11:19:05.416-01	149	2
134	fazenda	06:00:00	14:00:00	1	2018-10-31	2018-10-31	4	3	3	4	4	3	4	4	4	4	4	3	3	4	4		Narciso Afonso	Janice Semedo	2018-11-10 11:20:50.912-01	2018-11-10 11:20:50.912-01	108	2
135	fazenda	06:00:00	14:00:00	1	2018-11-03	2018-11-03	3	2	3	2	2	2	3	3	3	3	2	2	3	3	2		Narciso Afonso	Julio César	2018-11-10 11:22:50.257-01	2018-11-10 11:22:50.257-01	108	2
136	fazenda	06:00:00	14:00:00	1	2012-11-03	2018-11-03	4	3	4	4	4	3	4	3	4	4	4	3	3	4	4		Narciso Afonso	Janice Semedo	2018-11-10 11:25:01.558-01	2018-11-10 11:25:01.558-01	108	2
137	fazenda	14:00:00	22:00:00	1	2018-10-31	2018-10-31	4	4	4	5	4	3	4	4	4	4	4	3	3	4	4		Narciso Afonso	Janice Semedo	2018-11-10 11:32:17.986-01	2018-11-10 11:32:17.986-01	115	2
138	fazenda	14:00:00	22:00:00	1	2018-11-02	2018-11-02	3	4	3	4	4	2	4	3	4	4	3	3	3	4	3		Narciso Afonso	Julio César	2018-11-10 11:44:10.581-01	2018-11-10 11:44:10.581-01	115	2
139	fazenda	14:00:00	18:00:00	1	2018-11-03	2018-11-03	4	5	4	5	4	3	4	4	4	4	4	4	3	4	4		Narciso Afonso	Janice Semedo	2018-11-10 11:45:39.382-01	2018-11-10 11:45:39.382-01	115	2
140	fazenda	06:00:00	14:00:00	1	2018-10-31	2018-10-31	3	4	4	4	4	4	4	4	4	4	4	3	3	4	4		Narciso Afonso	Janice Semedo	2018-11-10 11:47:30.879-01	2018-11-10 11:47:30.879-01	109	2
141	fazenda	06:00:00	14:00:00	1	2018-11-03	2018-11-03	4	3	4	3	4	4	3	4	4	4	4	4	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 11:49:22.017-01	2018-11-10 11:49:22.017-01	109	2
142	fazenda	14:00:00	22:00:00	1	2018-11-02	2018-11-02	3	3	4	3	3	4	2	3	3	2	3	2	2	2	3	Trabalha bem na caixa, mas tem problema na vista	Narciso Afonso	Julio César	2018-11-10 11:51:54.259-01	2018-11-10 11:51:54.259-01	113	2
143	fazenda	14:00:00	22:00:00	1	2018-11-02	2018-11-02	2	3	3	3	3	3	3	3	3	3	3	3	3	3	3		Narciso Afonso	Julio César	2018-11-10 11:53:11.668-01	2018-11-10 11:53:11.668-01	106	2
144	fazenda	06:00:00	14:00:00	1	2018-11-03	2018-11-03	4	3	4	3	4	4	3	3	4	3	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 11:54:51.126-01	2018-11-10 11:54:51.126-01	110	2
145	fazenda	06:00:00	14:00:00	1	2018-11-03	2018-11-03	3	4	4	4	3	4	3	3	4	4	4	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 11:57:00.155-01	2018-11-10 11:57:00.155-01	149	2
146	fazenda	06:00:00	14:00:00	1	2018-11-10	2018-11-10	4	3	4	3	3	4	3	3	4	4	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 12:07:57.129-01	2018-11-10 12:07:57.129-01	110	2
147	fazenda	06:00:00	14:00:00	1	2018-11-10	2018-11-10	3	4	3	4	4	4	3	3	3	4	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 12:10:16.986-01	2018-11-10 12:10:16.986-01	149	2
148	fazenda	06:00:00	14:00:00	1	2018-11-10	2018-11-10	4	4	4	4	3	3	4	3	4	3	4	3	3	4	4		Narciso Afonso	Janice Semedo	2018-11-10 12:16:51.345-01	2018-11-10 12:16:51.345-01	108	2
149	fazenda	06:00:00	14:00:00	1	2018-11-10	2018-11-10	3	4	4	3	4	4	3	3	4	3	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 12:18:18.326-01	2018-11-10 12:18:18.326-01	109	2
150	achada	06:00:00	14:00:00	2	2018-11-10	2018-11-10	4	5	4	5	5	5	5	5	5	5	4	5	5	5	4		Narciso Afonso	Wilson Oliveira	2018-11-10 12:20:07.463-01	2018-11-10 12:20:07.463-01	112	2
151	achada	06:00:00	14:00:00	2	2018-11-10	2018-11-10	4	5	4	5	5	5	5	5	5	5	4	5	4	5	5		Narciso Afonso	Wilson Oliveira	2018-11-10 12:21:34.553-01	2018-11-10 12:21:34.553-01	114	2
152	fazenda	06:00:00	22:00:00	1	2018-11-10	2018-11-10	3	5	4	5	5	4	5	5	4	5	4	5	4	5	5		Narciso Afonso	Wilson Oliveira	2018-11-10 12:24:20.755-01	2018-11-10 12:24:20.755-01	103	2
153	s_domingos	10:00:00	14:00:00	3	2018-10-27	2018-11-02	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4		Narciso Afonso	Adilson Mendes	2018-11-10 12:28:07.275-01	2018-11-10 12:28:07.275-01	17	2
154	fazenda	08:00:00	12:00:00	1	2018-10-29	2018-11-04	3	4	3	4	3	3	3	3	4	4	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 12:30:19.758-01	2018-11-10 12:30:19.758-01	68	2
155	fazenda	10:00:00	14:00:00	1	2018-10-26	2018-10-01	3	4	3	3	3	4	3	3	4	4	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 12:36:15.137-01	2018-11-10 12:36:15.137-01	36	2
156	fazenda	10:00:00	14:00:00	1	2018-10-25	2018-10-31	3	3	4	3	3	4	3	3	3	3	3	3	3	3	4		Narciso Afonso	Janice Semedo	2018-11-10 12:41:38.464-01	2018-11-10 12:41:38.464-01	67	2
157	fazenda	10:00:00	14:00:00	1	2018-11-02	2018-11-08	4	2	3	2	3	3	3	3	3	3	3	3	3	3	3		Narciso Afonso	Janice Semedo	2018-11-10 12:42:53.246-01	2018-11-10 12:42:53.246-01	39	2
158	achada	10:00:00	14:00:00	2	2018-10-31	2018-11-06	3	5	5	4	5	5	4	4	5	5	4	4	4	5	5		Narciso Afonso	Wilson Oliveira	2018-11-10 12:45:08.652-01	2018-11-10 12:45:08.652-01	38	2
159	achada	10:00:00	14:00:00	2	2018-10-25	2018-10-31	4	5	5	5	5	4	5	5	5	5	4	4	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-10 12:46:55.148-01	2018-11-10 12:46:55.148-01	72	2
160	achada	06:00:00	10:00:00	2	2018-09-22	2018-09-28	4	5	5	4	5	5	4	5	5	5	4	4	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-10 12:49:30.831-01	2018-11-10 12:49:30.831-01	74	2
161	achada	10:00:00	14:00:00	2	2018-10-31	2018-11-06	4	5	5	5	5	5	5	5	5	5	5	5	5	5	5		Narciso Afonso	Wilson Oliveira	2018-11-10 12:50:55.047-01	2018-11-10 12:50:55.047-01	6	2
162	achada	14:00:00	22:00:00	2	2018-11-13	2018-11-13	4	4	5	3	4	4	4	3	3	4	4	4	3	4	5	precisa um pouco mais de pulso em relação aos assistentes muitas vezes observo que ela em vez de mandar fazer alguma coisa dentro da loja ela mesmo faça .\r\nmas do resto trabalha muito bem e  é muito empenhada	Narciso Afonso	Emanuel Cabral	2018-11-13 12:25:20.551-01	2018-11-13 12:25:20.551-01	89	2
163	s_domingos	14:00:00	22:00:00	3	2018-11-13	2018-11-13	4	3	5	4	4	3	3	4	4	3	3	3	4	3	3	trabalha muito bem faz sempre algo para puxar as vendas ,esta sempre a procura de clientes novos no sentido de aumentar as vendas.\r\nnesses últimos dias tenho estado a lhe pedir para chegar a loja mais cedo esta a dar desculpas , e também as vezes não trás uniforme	Narciso Afonso	Emanuel Cabral	2018-11-13 12:30:02.339-01	2018-11-13 12:30:02.339-01	90	2
164	achada	06:00:00	14:00:00	2	2018-11-13	2018-11-13	4	4	4	4	4	3	5	4	4	4	4	4	3	5	4	trabalha bem muito, preocupado com a loja esta sempre .\r\n	Narciso Afonso	Emanuel Cabral	2018-11-13 12:32:30.538-01	2018-11-13 12:32:30.538-01	91	2
165	fazenda	10:00:00	22:00:00	1	2018-11-13	2018-11-13	4	4	4	5	4	3	5	4	5	5	5	5	4	5	5	esta a fazer um bom trabalho mas nesse momento precisa de uma pessoa que trabalha bem na caixa para as vendas subirem .\r\nreparei também que deixa os assistentes um pouco a vontade .	Narciso Afonso	Emanuel Cabral	2018-11-13 12:35:48.772-01	2018-11-13 12:35:48.772-01	97	2
166	s_domingos	06:00:00	14:00:00	3	2018-11-13	2018-11-13	4	2	4	3	3	3	3	3	4	4	3	4	3	3	4	precisa melhorar o seu trabalho	Narciso Afonso	Emanuel Cabral	2018-11-13 12:40:56.296-01	2018-11-13 12:40:56.296-01	98	2
167	fazenda	06:00:00	14:00:00	1	2018-11-13	2018-11-13	4	4	3	3	3	4	3	4	4	4	3	4	4	3	5	faz  o seu trabalho , tem se esforçado .\r\n mas comunicar com ela è difícil , limita muito os seus assistentes 	Narciso Afonso	Emanuel Cabral	2018-11-13 12:50:07.178-01	2018-11-13 12:50:07.178-01	102	2
\.


--
-- Data for Name: formations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formations (id, name, description, teoric_part, pratic_part, subscription_cost, certificate_cost, "createdAt", "updatedAt") FROM stdin;
1	Técnicas de Vendas e fidelização/assistente ao cliente, Técnicas de Gestão de stock+		6	84	4500	1500	2018-10-17 12:04:06.891-01	2018-10-17 12:04:06.891-01
2	Técnicas de Gestão de lojas e armazéns - Responsável de loja		6	84	4500	2000	2018-10-17 12:05:02.22-01	2018-10-17 12:05:02.22-01
\.


--
-- Data for Name: increases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.increases (id, quantity, reason, "createdAt", "updatedAt", "personId", "userId") FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, "toPay", paid, discount, "createdAt", "updatedAt", "personId") FROM stdin;
39	6000	1000	0	2018-10-26 12:53:07.613-01	2018-10-29 12:01:17.915-01	45
9	6000	4500	0	2018-10-17 16:47:53.382-01	2018-11-06 10:45:19.023-01	10
26	6000	0	0	2018-10-22 15:22:19.647-01	2018-10-22 15:22:19.647-01	31
27	6000	0	0	2018-10-22 15:31:48.315-01	2018-10-22 15:31:48.315-01	32
1	6000	1000	0	2018-10-17 12:06:20.298-01	2018-10-17 12:07:48.206-01	\N
28	6000	1000	0	2018-10-23 08:39:51.835-01	2018-10-23 08:40:03.392-01	33
57	6000	0	0	2018-10-29 14:45:30.592-01	2018-10-29 14:45:30.592-01	64
2	10500	2500	16	2018-10-17 12:13:24.587-01	2018-10-17 12:19:33.198-01	2
4	6000	0	0	2018-10-17 14:51:18.003-01	2018-10-17 14:51:18.003-01	5
5	6000	4500	0	2018-10-17 15:09:56.09-01	2018-10-17 15:10:27.306-01	6
29	6000	4000	0	2018-10-23 15:52:06.332-01	2018-10-23 15:52:19.447-01	34
30	6000	4500	0	2018-10-24 14:44:42.39-01	2018-10-24 14:45:47.727-01	35
6	6000	4500	0	2018-10-17 15:21:35.233-01	2018-10-17 15:22:29.939-01	7
71	10500	10500	16	2018-10-30 09:15:39.971-01	2018-11-08 13:25:42.69-01	78
8	10500	0	16	2018-10-17 15:28:34.893-01	2018-10-17 15:28:34.893-01	9
7	6000	4500	0	2018-10-17 15:24:46.483-01	2018-11-06 17:21:40.8-01	8
10	6000	4500	0	2018-10-18 10:26:38.223-01	2018-10-18 10:27:38.49-01	12
11	6000	4500	0	2018-10-19 08:53:28.32-01	2018-10-19 08:53:38.197-01	13
58	6000	1000	0	2018-10-29 16:14:30.223-01	2018-10-29 16:14:53.749-01	65
31	10500	10500	16	2018-10-24 16:12:02.654-01	2018-10-24 16:12:25.165-01	36
12	10500	1000	16	2018-10-19 08:56:52.4-01	2018-10-19 08:57:48.054-01	14
13	6000	4000	0	2018-10-19 09:00:53.024-01	2018-10-19 09:01:13.06-01	15
25	6000	6000	0	2018-10-22 14:27:34.197-01	2018-11-05 11:10:34.33-01	30
59	10500	10500	16	2018-10-29 16:46:45.439-01	2018-10-29 16:47:17.672-01	66
14	6000	4000	0	2018-10-19 09:05:05.074-01	2018-10-19 09:07:59.803-01	16
34	6000	4500	0	2018-10-25 09:07:25.35-01	2018-10-25 09:08:07.368-01	39
33	0	4500	0	2018-10-25 08:56:41.639-01	2018-10-25 10:08:34.382-01	38
3	6000	4500	0	2018-10-17 14:42:52.995-01	2018-10-26 09:08:16.643-01	4
60	6000	6000	0	2018-10-29 16:48:39.564-01	2018-10-29 16:48:45.664-01	67
75	6000	4000	0	2018-10-30 09:38:25.318-01	2018-10-30 09:38:35.625-01	82
15	6000	4500	0	2018-10-19 09:11:06.759-01	2018-10-19 09:12:44.651-01	17
61	10500	0	16	2018-10-29 16:50:39.443-01	2018-10-29 16:51:01.752-01	68
16	0	1000	0	2018-10-19 11:35:02.643-01	2018-10-19 11:35:31.329-01	20
17	6000	1000	0	2018-10-19 12:03:03.26-01	2018-10-19 12:07:27.546-01	21
18	6000	0	0	2018-10-19 12:13:12.604-01	2018-10-19 12:13:12.604-01	22
19	6000	0	0	2018-10-19 15:19:23.66-01	2018-10-19 15:19:23.66-01	23
20	6000	2000	0	2018-10-22 09:47:58.851-01	2018-10-22 09:48:23.158-01	24
35	6000	4500	0	2018-10-26 09:12:20.629-01	2018-10-26 09:12:56.724-01	41
21	6000	4500	0	2018-10-22 13:32:08.585-01	2018-10-22 13:32:26.262-01	26
36	6000	0	0	2018-10-26 10:33:54.958-01	2018-10-26 10:33:54.958-01	42
22	6000	4500	0	2018-10-22 13:33:33.442-01	2018-10-22 13:33:49.935-01	27
23	6000	4500	0	2018-10-22 13:35:09.463-01	2018-10-22 13:35:14.56-01	28
37	6000	0	0	2018-10-26 10:35:44.509-01	2018-10-26 10:35:44.509-01	43
24	6000	4500	0	2018-10-22 13:36:51.094-01	2018-10-22 13:37:02.869-01	29
38	10500	0	16	2018-10-26 11:20:06.17-01	2018-10-26 11:48:14.251-01	44
76	12500	0	0	2018-10-30 09:45:56.067-01	2018-10-30 09:45:56.067-01	83
62	6000	4500	0	2018-10-29 16:52:27.006-01	2018-10-29 16:52:44.868-01	69
41	6000	6000	0	2018-10-26 14:40:13.329-01	2018-10-26 14:40:52.471-01	47
40	6000	4500	0	2018-10-26 14:36:05.192-01	2018-10-26 14:41:37.851-01	46
63	6000	6000	0	2018-10-30 08:56:47.41-01	2018-10-30 08:56:54.226-01	70
77	6000	0	0	2018-10-30 09:49:02.212-01	2018-10-30 09:49:02.212-01	84
42	6000	6000	0	2018-10-26 14:46:19.139-01	2018-10-26 14:47:15.59-01	48
64	6000	4500	0	2018-10-30 08:59:50.865-01	2018-10-30 09:00:07.752-01	71
43	6000	4500	0	2018-10-26 14:50:08.197-01	2018-10-26 14:50:26.753-01	49
44	6000	4500	0	2018-10-26 14:54:38.017-01	2018-10-26 14:54:57.04-01	50
45	10500	0	16	2018-10-26 14:59:36.983-01	2018-10-26 14:59:36.983-01	51
46	6000	0	0	2018-10-26 15:04:45.578-01	2018-10-26 15:04:45.578-01	52
47	6000	4500	0	2018-10-26 15:09:54.907-01	2018-10-26 15:10:01.702-01	53
65	6000	4500	0	2018-10-30 09:02:14.024-01	2018-10-30 09:02:21.115-01	72
48	6000	4500	0	2018-10-26 15:12:07.878-01	2018-10-26 15:14:55.944-01	54
49	6000	4500	0	2018-10-26 15:28:41.537-01	2018-10-26 15:34:31.906-01	55
66	6000	6000	0	2018-10-30 09:04:24.086-01	2018-10-30 09:04:30.512-01	73
50	6000	6000	0	2018-10-26 15:54:25.555-01	2018-10-26 15:54:51.967-01	56
51	6000	4500	0	2018-10-26 15:59:27.588-01	2018-10-26 15:59:40.313-01	57
78	6000	0	0	2018-10-30 09:52:09.505-01	2018-10-30 09:52:09.505-01	85
67	6000	5000	0	2018-10-30 09:05:50.594-01	2018-10-30 09:06:25.024-01	74
52	6000	4500	0	2018-10-26 16:03:11.295-01	2018-10-26 16:03:50.133-01	58
53	6000	6000	0	2018-10-26 16:07:05.402-01	2018-10-26 16:07:22.232-01	59
54	6000	4500	0	2018-10-26 16:15:50.772-01	2018-10-26 16:16:11.295-01	60
55	6000	6000	0	2018-10-26 16:39:02.999-01	2018-10-26 16:39:36.231-01	61
56	6000	0	0	2018-10-26 17:45:49.858-01	2018-10-26 17:45:49.858-01	62
79	6000	0	0	2018-10-30 09:54:42.27-01	2018-10-30 09:54:42.27-01	86
68	6000	4500	0	2018-10-30 09:08:25.204-01	2018-10-30 09:08:57.785-01	75
81	6000	5000	0	2018-10-30 10:53:24.157-01	2018-10-30 10:53:39.808-01	88
69	10500	10500	16	2018-10-30 09:11:04.19-01	2018-10-30 09:11:38.236-01	76
70	10500	9000	16	2018-10-30 09:13:38.156-01	2018-10-30 09:13:47.602-01	77
82	8000	6000	36	2018-10-30 10:59:13.847-01	2018-10-30 10:59:21.33-01	89
89	6000	4500	0	2018-10-30 11:33:12.689-01	2018-11-09 17:40:17.606-01	96
72	6000	4500	0	2018-10-30 09:18:23.101-01	2018-10-30 09:18:35.621-01	79
83	8000	6000	36	2018-10-30 11:02:38.484-01	2018-10-30 11:02:46.507-01	90
73	6000	4500	0	2018-10-30 09:20:08.879-01	2018-10-30 09:20:27.843-01	80
74	10500	8000	16	2018-10-30 09:29:54.595-01	2018-10-30 09:30:02.286-01	81
84	8000	4000	36	2018-10-30 11:05:19.777-01	2018-10-30 11:05:26.866-01	91
85	8000	4000	36	2018-10-30 11:11:31.028-01	2018-10-30 11:11:47.757-01	92
94	6000	0	0	2018-10-30 12:02:16.064-01	2018-10-30 12:02:16.064-01	101
95	12500	0	0	2018-10-30 12:08:24.907-01	2018-10-30 12:08:24.907-01	102
86	8000	5000	36	2018-10-30 11:16:54.049-01	2018-10-30 11:20:22.596-01	93
87	6000	0	0	2018-10-30 11:24:20.847-01	2018-10-30 11:24:20.847-01	94
88	6000	5000	0	2018-10-30 11:29:45.197-01	2018-10-30 11:29:50.666-01	95
90	8000	0	36	2018-10-30 11:37:38.169-01	2018-10-30 11:37:38.169-01	97
91	8000	4000	36	2018-10-30 11:40:32.396-01	2018-10-30 11:40:39.732-01	98
92	8000	0	36	2018-10-30 11:44:47.3-01	2018-10-30 11:44:47.3-01	99
93	8000	5000	36	2018-10-30 11:48:07.508-01	2018-10-30 11:48:22.453-01	100
96	6000	0	0	2018-10-30 12:17:29.095-01	2018-10-30 12:17:29.095-01	103
101	8000	8000	36	2018-10-30 12:31:13.913-01	2018-10-30 12:31:20.179-01	108
99	6000	4500	0	2018-10-30 12:24:52.272-01	2018-10-30 12:25:03.035-01	106
97	6000	6000	0	2018-10-30 12:19:28.992-01	2018-10-30 12:19:52.309-01	104
98	6000	4500	0	2018-10-30 12:22:29.305-01	2018-10-30 12:22:41.421-01	105
100	6000	6000	0	2018-10-30 12:28:22.98-01	2018-10-30 12:28:29.66-01	107
102	6000	0	0	2018-10-30 12:36:58.633-01	2018-10-30 12:36:58.633-01	109
103	8000	8000	36	2018-10-30 12:42:52.294-01	2018-10-30 12:43:11.089-01	110
104	8000	6000	36	2018-10-30 12:48:09.934-01	2018-10-30 12:48:21.464-01	111
105	8000	7000	36	2018-10-30 13:08:40.189-01	2018-10-30 13:10:29.556-01	112
106	8000	0	36	2018-10-30 13:14:39.126-01	2018-10-30 13:14:39.126-01	113
107	6000	5000	0	2018-10-30 13:18:52.202-01	2018-10-30 13:19:04.583-01	114
108	8000	8000	36	2018-10-30 13:23:18.903-01	2018-10-30 13:23:53.929-01	115
109	6000	4500	0	2018-10-30 15:37:43.092-01	2018-10-30 15:39:02.779-01	116
110	6000	4500	0	2018-10-30 17:22:03.669-01	2018-10-30 17:22:25.989-01	117
111	6000	4500	0	2018-10-30 17:25:54.288-01	2018-10-30 17:26:12.452-01	118
112	6000	4500	0	2018-10-30 17:28:50.998-01	2018-10-30 17:29:32.746-01	119
113	6000	4500	0	2018-10-30 17:32:32.596-01	2018-10-30 17:33:08.154-01	120
114	6000	4500	0	2018-10-30 17:37:22.372-01	2018-10-30 17:38:25.339-01	121
32	6000	6000	0	2018-10-24 16:19:33.209-01	2018-11-05 10:53:17.51-01	37
115	10500	10500	16	2018-10-31 11:44:55.077-01	2018-10-31 11:45:03.401-01	122
116	10500	10500	16	2018-10-31 12:57:01.982-01	2018-10-31 12:57:08.887-01	123
117	6000	4500	0	2018-10-31 13:06:10.714-01	2018-10-31 13:06:22.777-01	124
119	6000	5000	0	2018-10-31 14:58:33.163-01	2018-10-31 14:59:19.662-01	126
120	12500	8000	0	2018-10-31 15:03:22.84-01	2018-10-31 15:04:28.538-01	127
121	6000	6000	0	2018-10-31 15:08:03.738-01	2018-10-31 15:08:47.22-01	128
122	6000	2000	0	2018-10-31 15:13:01.951-01	2018-10-31 15:13:16.386-01	\N
123	6000	4500	0	2018-10-31 15:35:56.031-01	2018-10-31 15:36:28.1-01	130
118	6000	1000	0	2018-10-31 14:49:15.17-01	2018-10-31 16:20:19-01	125
124	6000	4500	0	2018-10-31 16:30:32.271-01	2018-10-31 16:31:27.435-01	131
125	6000	0	0	2018-10-31 16:37:50.486-01	2018-10-31 16:37:50.486-01	132
126	12500	9000	0	2018-10-31 16:41:56.737-01	2018-10-31 16:42:34.85-01	133
127	12500	9000	0	2018-10-31 16:47:47.74-01	2018-10-31 16:48:37.096-01	134
128	6000	6000	0	2018-10-31 16:56:05.48-01	2018-10-31 16:56:43.741-01	135
129	6000	6000	0	2018-10-31 17:24:55.519-01	2018-10-31 17:25:11.749-01	136
130	6000	4500	0	2018-10-31 17:27:54.215-01	2018-10-31 17:28:34.507-01	137
131	6000	4500	0	2018-10-31 17:35:55.199-01	2018-10-31 17:36:38.283-01	138
132	6000	4500	0	2018-10-31 17:41:27.22-01	2018-10-31 17:41:40.387-01	139
134	6000	4500	0	2018-11-02 15:58:06.009-01	2018-11-02 16:00:18.847-01	141
135	6000	4500	0	2018-11-02 16:04:33.502-01	2018-11-02 16:05:34.146-01	142
136	6000	1000	0	2018-11-05 09:23:09.818-01	2018-11-05 09:23:18.12-01	25
138	6000	0	0	2018-11-05 09:50:41.18-01	2018-11-05 09:50:41.18-01	143
139	6000	0	0	2018-11-05 11:04:22.218-01	2018-11-05 11:04:22.218-01	144
140	6000	1000	0	2018-11-05 12:03:18.335-01	2018-11-05 12:09:22.636-01	145
141	6000	0	0	2018-11-06 10:34:26.286-01	2018-11-06 10:34:26.286-01	146
142	6000	0	0	2018-11-06 12:35:52.216-01	2018-11-06 12:35:52.216-01	147
143	10500	0	16	2018-11-06 15:44:30.775-01	2018-11-06 15:44:30.775-01	148
144	8500	0	32	2018-11-08 12:19:44.274-01	2018-11-08 12:19:44.274-01	149
145	6000	0	0	2018-11-08 12:40:01.719-01	2018-11-08 12:40:01.719-01	150
146	6000	4500	0	2018-11-09 09:40:47.549-01	2018-11-09 09:40:59.366-01	151
147	6000	0	0	2018-11-09 10:25:06.202-01	2018-11-09 10:25:06.202-01	152
80	6000	4500	0	2018-10-30 10:14:50.864-01	2018-11-09 13:55:53.953-01	87
148	6000	6000	0	2018-11-12 10:39:38.718-01	2018-11-12 10:39:50.377-01	153
133	6000	4500	0	2018-11-02 15:19:41.605-01	2018-11-12 10:54:10.853-01	140
149	6000	0	0	2018-11-12 17:26:01.714-01	2018-11-12 17:26:01.714-01	154
150	6000	0	0	2018-11-13 10:34:46.462-01	2018-11-13 10:34:46.462-01	155
137	6000	4500	0	2018-11-05 09:33:52.279-01	2018-11-13 10:39:26.859-01	63
151	6000	0	0	2018-11-13 10:50:01.096-01	2018-11-13 10:50:01.096-01	157
152	6000	0	0	2018-11-13 10:55:07.552-01	2018-11-13 10:55:07.552-01	158
153	6000	0	0	2018-11-13 10:59:41.727-01	2018-11-13 10:59:41.727-01	159
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.people (id, name, birthdate, address, phone, email, bi, nif, gender, state, score, "scoreText", "createdAt", "updatedAt", "userId") FROM stdin;
21	Natalina De Jesus Nunes Semedo	1996-12-12	Calheta	9278972 / 2731062		441356	144135604	female	formation	\N	\N	2018-10-19 12:02:54.33-01	2018-10-29 09:02:55.735-01	2
14	Evinardia Nancy Sousa	1996-03-20	Palmarejo	9233934		427821	142782190	female	formation	\N	\N	2018-10-19 08:55:36.558-01	2018-10-22 08:48:46.855-01	2
22	Jassica Jailma Barreto Semedo	1998-02-21	Calabaceira	5268929 / 9297155		454950	145495000	female	registered	\N	\N	2018-10-19 12:13:03.977-01	2018-10-22 08:49:35.744-01	2
15	Carla Sofia Alfama Barros	1995-12-17	Castelão	9269332		425935	142593500	female	formation	\N	\N	2018-10-19 09:00:46.003-01	2018-10-22 09:35:40.656-01	2
54	Jacqueline Afonso Correia	1992-12-18	Palmarejo	9113370		364982	136498256	female	reserved	3.61999989	Suficiente	2018-10-26 15:11:57.52-01	2018-10-31 14:45:23.504-01	2
43	Miriam Tatiana mendes Almeida	2000-03-31	Pensamento	9233654		479459	147945909	female	registered	\N	\N	2018-10-26 10:35:34.796-01	2018-10-26 10:35:53.17-01	2
57	Elisa Semedo Barreto	1999-03-23	Palmarejo	5228465		467592	146759206	female	reserved	4	Bom	2018-10-26 15:58:59.591-01	2018-11-05 11:17:38.964-01	2
42	Andreia Patricia Moreno Tavares	1998-05-25	Pensamento	9899374		457268	145726800	female	registered	\N	\N	2018-10-26 10:33:26.254-01	2018-10-26 10:36:16.237-01	2
12	Admilson Gomes De Pina	1999-07-30	Safende	9743647 / 9147573	kedeny673@gmail.com	473603	147360307	male	internship	\N	\N	2018-10-18 10:26:27.158-01	2018-10-26 10:39:05.84-01	2
39	Allyson Jayne Monteiro Mendes	1991-11-28	Palmarejo	9947584/9917325		329729	132972956	female	internship	3.03999996	Suficiente	2018-10-25 09:04:25.908-01	2018-11-10 12:42:53.527-01	2
5	Nicolas Sanches Duarte Lopes	1994-07-08	Bairro Craveiro Lopes	9363429		384454	138445400	male	registered	\N	\N	2018-10-17 14:51:05.868-01	2018-10-17 15:19:04.397-01	2
33	Euclides Sony Gonçalves Semedo	1987-10-12	São Felipe	9353474		224590	122459091	male	formation	\N	\N	2018-10-23 08:39:45.002-01	2018-10-29 09:04:19.088-01	2
34	Edna Cristina De Brito	1995-12-24	Monte Negro	9364381		428945	142894583	female	formation	\N	\N	2018-10-23 15:52:02.32-01	2018-10-23 15:52:32.523-01	2
58	Maria da Graça Correia Barreto	1988-09-14	Safende	9234767		283909	128390948	female	reserved	3.42000008	Suficiente	2018-10-26 16:02:50.344-01	2018-11-05 12:33:56.415-01	2
29	Nelida Samira Nascimento Ribeiro	1995-06-13	Ribeirão Chiqueiro	5166635		400849	140084908	female	reserved	4.55000019	Bom	2018-10-22 13:36:45.721-01	2018-11-05 15:45:22.682-01	2
27	Marly Brito Soares	1982-07-14	Achadinha	9754652		154589	115458956	female	reserved	\N	\N	2018-10-22 13:33:28.827-01	2018-10-22 13:34:03.218-01	2
24	Denise Lurena Andrade Semrdo	1990-09-30	Fazenda	9874421	denisesemedo9@hotmail.com	323004	132300427	female	formation	\N	\N	2018-10-22 09:47:24.159-01	2018-10-29 09:03:17.981-01	2
36	Sandra Cristina Fernandes Fortes Cabral	1983-01-01	Achada Lém	9839742		85121	108512169	female	reserved	3.63000011	Suficiente	2018-10-24 16:11:53.296-01	2018-11-12 16:23:50.809-01	2
28	Marla Tatiana Monteiro	1992-12-02	Palmarejo	9546979		347877	134787706	female	reserved	4.17000008	Bom	2018-10-22 13:35:02.591-01	2018-11-02 09:57:49.029-01	2
38	Livandra Tavares Monteiro	1994-10-26	Vila Nova	5984064		388693	138869308	female	internship	3.71000004	Suficiente	2018-10-25 08:56:09.288-01	2018-11-10 12:45:08.933-01	2
23	Vanusa De Livramento Sanches Duarte Lopes	1985-01-12	Fazenda	5242242		135547	113554761	female	registered	\N	\N	2018-10-19 15:19:13.227-01	2018-10-19 15:19:40.081-01	2
2	Maria Mendes De Pina	1996-11-26	Coqueiro	9504003	marina1996@gmail.com	43259	14325909	female	formation	\N	\N	2018-10-17 12:13:03.681-01	2018-10-22 08:46:40.609-01	2
16	Maria De Jesus Moreira De Pina	1994-01-27	Achada Grande Frente	5293605		426183	142618300	female	internship	\N	\N	2018-10-19 09:04:56.892-01	2018-10-31 10:36:11.477-01	2
8	Nayma Etelvina Dos Reis Ramos	1997-03-01	Palmarejo	5961230		439824	143982400	female	formation	\N	\N	2018-10-17 15:24:37.3-01	2018-10-22 08:47:13.421-01	2
9	Dulceana Fernandes Tavares	1999-08-30	Coqueiro	9853548 / 9989758		466195	146619500	female	formation	\N	\N	2018-10-17 15:26:56.492-01	2018-10-22 08:47:28.974-01	2
35	Edson Patrick Dos Santos	1998-08-15	Achadinha	9918478	edsonkalifa6@gmailcom	454396	145439666	male	reserved	3.42000008	Suficiente	2018-10-24 14:11:15.384-01	2018-11-12 16:26:48.486-01	2
11	Lenira Dias Lopes	1985-03-03	Achadinha	9124073		169481	11694811	female	formation	\N	\N	2018-10-17 16:49:20.563-01	2018-10-22 08:48:04.477-01	2
53	Eveline Rosa Duarte Dos Reis	1997-03-22	Orgãos	9247370		440550	144055007	female	reserved	3.48000002	Suficiente	2018-10-26 15:09:47.132-01	2018-11-05 15:49:17.105-01	2
6	Ironise Ramos Lima	1994-11-21	São Pedro	9964351	ronicelima12@gmail.com	402608	140260820	female	internship	4.80000019	Bom	2018-10-17 15:09:47.64-01	2018-11-10 12:50:55.343-01	2
20	Maria Jose Tavares Fernandes	1994-10-02	São Pedro	9220041 / 9111739		491253	149125380	female	gave_up	\N	\N	2018-10-19 11:34:54.461-01	2018-10-22 14:51:19.311-01	2
31	Claudilene Moreira Tavares	1995-04-06	Ponta d Agua	9221839 / 9364117		395133	139513302	female	formation	\N	\N	2018-10-22 15:22:11.559-01	2018-10-22 15:22:19.557-01	2
32	Aleida Solangela Fernandes Duarte	1993-04-29	Achada Lém	9340283 / 9219005		364737	136473700	female	formation	\N	\N	2018-10-22 15:31:02.855-01	2018-10-22 15:31:48.229-01	2
25	Keviny Lopes	1997-09-11	São Felipe	9261687 / 5989088		444197	1444197	male	formation	\N	\N	2018-10-22 12:11:44.326-01	2018-11-05 17:05:45.783-01	2
10	Erico Tavares Duarte Amarante	1995-07-28	A.S.A	9131658		396666	139666605	male	internship	\N	\N	2018-10-17 16:47:41.789-01	2018-11-06 10:45:33.831-01	2
50	Delfina Almeida Martins	1997-07-22	São Martinho	9142912		435914	143591460	female	reserved	2.52999997	Insuficiente	2018-10-26 14:54:28.977-01	2018-11-05 15:51:18.216-01	2
17	Alexsandro Jorge Varela Dos Santos	1991-11-22	Palmarejo	5930428 / 5921154		367782	136778291	male	reserved	4.38000011	Bom	2018-10-19 09:10:38.418-01	2018-11-12 16:25:53.334-01	2
30	Telma Djennnifer Semedo Teixeira	1996-12-04	Vila Nova	5982840	teixeira semedo347@gmail.com	421288	142128805	female	internship	\N	\N	2018-10-22 14:26:52.3-01	2018-10-25 08:59:11.974-01	2
46	Marlene Sofia Lima Lopes	1990-07-01	Castelão	9257972		342418	134241800	female	reserved	\N	\N	2018-10-26 14:35:55.732-01	2018-10-26 14:36:14.355-01	2
41	Lenira Frederico Mendes	1996-06-10	Eugênio Lima	9144833		422053	142205303	female	internship	\N	\N	2018-10-26 09:12:14.816-01	2018-10-26 09:13:16.098-01	2
44	Fabio Odair Mendes Andrade Vieira	1996-12-14	Vila Nova	5967218		425770	142577006	male	registered	\N	\N	2018-10-26 11:19:52.667-01	2018-10-26 11:48:25.738-01	2
47	Ideal Manuel Pereira De Jesus	1994-01-30	São Domingos	9921997 / 2681056		363089	136308902	male	reserved	\N	\N	2018-10-26 14:39:56.73-01	2018-10-26 14:42:05.085-01	2
7	Janice Socorro Nunes Da Moura	1996-01-22	Calheta	9272913		425196	142519600	female	internship	\N	\N	2018-10-17 15:21:26.995-01	2018-11-05 14:42:11.154-01	2
37	Jalise Darianne Furtado Gomes	1994-10-17	Santania	9889989		379915	137991509	female	internship	\N	\N	2018-10-24 16:19:16.972-01	2018-11-05 10:53:28.812-01	2
52	Diana Mendes Landim	1998-04-07	Santiago	9317146		456088	145608800	female	reserved	3.69000006	Suficiente	2018-10-26 15:01:38.966-01	2018-10-31 13:40:25.61-01	2
51	Eliane Patricia Mendes Gomes Da Costa	1993-05-10	Achadinha	5901076		358695	135869552	female	reserved	3.6500001	Suficiente	2018-10-26 14:59:09.637-01	2018-10-31 13:55:11.273-01	2
49	Mileida de Jesus Tavares Ribeiro	1995-09-25	Ponta d Agua	9228924		398481	139848100	female	reserved	3.95000005	Suficiente	2018-10-26 14:49:42.873-01	2018-11-05 15:53:04.672-01	2
48	Marcia Varela De Pina	1999-10-19	Assomada	5889198		470223	147022304	female	reserved	4.19999981	Bom	2018-10-26 14:45:00.656-01	2018-11-05 10:43:49.944-01	2
55	Magda Helena Semedo Moreno	1991-09-06	Monte Vermelho	9338625		344762	134476298	female	reserved	3.8900001	Suficiente	2018-10-26 15:28:30.886-01	2018-11-05 17:01:31.047-01	2
56	Romy Cristina Barros Ramos	1995-10-20	Ponta d Agua	9273926/5984007		424727	142472700	female	reserved	3.78999996	Suficiente	2018-10-26 15:53:31.28-01	2018-10-31 18:07:09.225-01	2
45	Nuémia Da Veiga Kargbo	1997-09-22	Fontes d Almeida	9775778		471684	147168406	female	formation	\N	\N	2018-10-26 12:52:48.113-01	2018-11-05 17:06:54.447-01	2
26	Antonia Cabral Da Luz	1995-02-15	Palmarejo	3270954		425622	142562203	female	reserved	3.78999996	Suficiente	2018-10-22 13:32:01.795-01	2018-11-05 13:01:07.796-01	2
4	Sony De Jesus Gomes Correia	1992-10-22	Achadinha	9235733		385795	138579598	female	formation	\N	\N	2018-10-17 14:42:32.212-01	2018-10-29 09:01:10.066-01	2
73	Ângela Semedo Varela	1981-01-07	A.S.A	9216333		46206	104620668	female	reserved	\N	\N	2018-10-30 09:04:02.587-01	2018-11-12 16:24:55.931-01	2
100	Emanuel Cabral Gomes	1989-12-25	Achada Grande Frente	9373264		300387	130038792	male	hired	\N	\N	2018-10-30 11:48:00.387-01	2018-10-30 11:48:34.375-01	2
75	Willian Fredy Lima Barbosa	1993-08-23	Achadinha	9966500 / 9371385		367169	136716938	male	internship	\N	\N	2018-10-30 09:08:20.482-01	2018-10-30 09:09:07.628-01	2
59	Dulcelina Do Carmo Silva Pires	1997-10-29	Achada Fátima	9231344		438468	143846809	female	reserved	3.33999991	Suficiente	2018-10-26 16:06:49.35-01	2018-11-05 12:07:05.257-01	2
61	Zenaida Da Luz Tavares Jorge	1887-07-04	Milho Branco	5286996		471887	147188700	female	reserved	\N	\N	2018-10-26 16:38:46.777-01	2018-10-26 16:39:50.037-01	2
108	Carlos Emanuel Barbosa De Pina	1988-12-27	São Felipe	5263145		292587	129258709	male	hired	3.6099999	Suficiente	2018-10-30 12:31:07.193-01	2018-11-10 12:16:51.696-01	2
69	António Alberto Mendes Fernades	1992-10-20	São Felipe	9117873		340911	134091159	male	internship	4.61999989	Bom	2018-10-29 16:52:22.057-01	2018-11-05 16:01:41.164-01	2
62	Delce de Jesus Semedo Tavares	1995-09-26	palmarejo	9360383	Delce.s.Tavares@gmail.com	403132	140313290	female	registered	\N	\N	2018-10-26 17:43:18.903-01	2018-10-26 17:49:41.925-01	5
64	Hélia Inocêncio Cabral	1998-06-27	Achada Grande Frente	9219025 / 2634868		449248	144924803	female	registered	\N	\N	2018-10-29 14:45:23.834-01	2018-10-29 14:45:45.557-01	2
106	Adelcia Almeida Varela	1995-03-12	São Martinho	9230014		403272	140327240	female	hired	2.94000006	Insuficiente	2018-10-30 12:24:47.177-01	2018-11-10 11:53:11.945-01	2
89	Catia Sofia Pereira Moreno Vieira	1994-03-14	Safende	9297057 / 9253514		382879	138287902	male	hired	3.92000008	Suficiente	2018-10-30 10:56:30.483-01	2018-11-13 12:25:20.877-01	2
103	Aires Albertino Rocha Afonso 	1997-10-09	Ponta d Agua	9236861		487453	148745300	male	hired	4.30999994	Bom	2018-10-30 12:17:24.337-01	2018-11-10 12:24:21.083-01	2
78	Felisberta Varela Tavares	1991-06-04	Palmarejo	9312760 / 9500685		347565	134756500	female	reserved	3.92000008	Suficiente	2018-10-30 09:15:31.941-01	2018-11-12 16:21:54.068-01	2
96	Jeisa De Jesus Moreira Fernandes	1993-11-30	Orgãos	5219888 / 2711071		364030	136403050	female	internship	\N	\N	2018-10-30 11:32:13.279-01	2018-11-13 11:43:08.007-01	2
86	Ângela De Jesus Moreira Monteiro	1993-11-01	Palmarejo	9221658		379610	137961006	female	hired	\N	\N	2018-10-30 09:54:29.974-01	2018-10-30 09:55:26.427-01	2
70	Vânia Patricia Moreira Barros	1995-11-16	Bela Vista	9723046 		425102	142510270	female	reserved	3.5999999	Suficiente	2018-10-30 08:56:42.177-01	2018-11-02 09:43:13.762-01	2
67	Jéssica Veiga Baessa Varela	1997-09-06	Santiago	9377115/ 9286386		456070	145607046	female	internship	3.20000005	Suficiente	2018-10-29 16:48:33.064-01	2018-11-10 12:41:38.823-01	2
80	Manuela De Jesus Landim Cardoso	1994-06-04	Eugênio Lima	9286837		383699	138369941	female	reserved	3.46000004	Suficiente	2018-10-30 09:20:04.445-01	2018-11-02 09:50:14.586-01	2
74	Joseane Alfama Marques	1994-07-09	Vila Nova	9734672		426846	142684600	female	reserved	3.96000004	Suficiente	2018-10-30 09:05:44.461-01	2018-11-12 16:24:18.086-01	2
79	Neuda Barros Resende	1996-01-11	São Felipe	5291457 / 9568346		426054	142605400	female	internship	\N	\N	2018-10-30 09:18:17.602-01	2018-10-30 09:18:50.789-01	2
76	Helder De Jesus Monteiro Semedo	1999-04-28	Loura	9156627 / 9823825		469210	146921046	male	reserved	4.34000015	Bom	2018-10-30 09:10:58.645-01	2018-11-12 15:55:49.013-01	2
92	Monica Sofia Moreira Da Rosa	1993-10-15	Ponta d Agua	9136051		367453	136745300	female	hired	4.44999981	Bom	2018-10-30 11:11:16.226-01	2018-11-07 16:59:53.369-01	2
72	Bruno Filipe Pereira Lopes	1996-09-23	Ponta d Agua	9252814 / 5825161		421116	1421116000	male	reserved	4.30999994	Bom	2018-10-30 09:02:09.566-01	2018-11-12 16:25:29.726-01	2
87	Lucy Vaz Ferreira	1993-02-06	Nossa Senhora Da Luz	9233715		385727	138572747	female	formation	\N	\N	2018-10-30 10:14:44.205-01	2018-11-05 17:09:51.075-01	2
63	Janice De Jesus Monteiro Lopes De Oliveira	1996-06-08	Achadinha	9148806		444304	144430400	female	formation	\N	\N	2018-10-29 10:09:38.596-01	2018-11-05 17:07:49.228-01	2
66	Elisandra Da Conceição Pina Silva	1995-04-24	São Felipe	9394095/ 9116010		402384	140238409	female	reserved	4.36000013	Bom	2018-10-29 16:46:04.306-01	2018-11-05 10:17:43.249-01	2
81	Ailton Alex Lopes Varela	1995-11-04	São Felipe	9273749		421547	142154709	male	hired	\N	\N	2018-10-30 09:29:43.869-01	2018-10-30 09:30:14.571-01	2
71	Claudia Ascenção Moreira Varela	1998-03-19	Ponta d Agua	9245448		448296	144829000	female	reserved	\N	\N	2018-10-30 08:59:40.662-01	2018-11-12 16:22:58.433-01	2
82	Vandonilson Soares Mendes	1984-12-11	Achada Grande Frente	9854377 / 9327824		27967	102796793	male	hired	\N	\N	2018-10-30 09:38:18.085-01	2018-10-30 09:38:52.371-01	2
83	Edmilson Lopes Barreto	1999-01-20	Eugênio Lima	9283662		486842	148684203	male	hired	\N	\N	2018-10-30 09:45:19.763-01	2018-10-30 09:46:10.125-01	2
93	Victor Manuel Tavares Vaz	1992-01-05	Eugênio Lima	9170852		342394	134239407	male	hired	\N	\N	2018-10-30 11:16:30.891-01	2018-10-30 11:21:31.104-01	2
84	Isaias De Jesus Freire Galvão	1995-06-27	Calabaceira	9174757		393846	139384600	male	hired	\N	\N	2018-10-30 09:48:48.193-01	2018-10-30 09:49:09.17-01	2
90	Adérito Varela Da Cruz Silva	1991-01-01	Palmarejo	9253503		381652	138165270	male	hired	3.86999989	Suficiente	2018-10-30 11:02:09.789-01	2018-11-13 12:30:02.535-01	2
85	Janice Baptista Gomes	1993-07-22	Vila Nova	9806634 		426531	142653110	female	hired	4.26999998	Bom	2018-10-30 09:51:38.699-01	2018-11-10 10:49:34.757-01	2
94	Cleida Silvania Soares Moreno	1999-01-08	São Felipe	9501177		466530	146653009	female	hired	\N	\N	2018-10-30 11:24:07.515-01	2018-10-30 11:24:28.986-01	2
97	Júlio César De Pina Tavares	1993-07-04	Achada Grande Frente	9320743		399009	139900985	male	hired	4.25	Bom	2018-10-30 11:37:30.775-01	2018-11-13 12:35:48.975-01	2
107	Elton Djony Querido Furtado	1996-04-20	A.S.A	9221940 / 9822251		460257	146025709	male	hired	4.03000021	Bom	2018-10-30 12:28:16.591-01	2018-11-10 10:44:20.394-01	2
95	Helder Da Moura Gonçalves	1993-10-27	Safende	9580263		360815	136081509	male	hired	\N	\N	2018-10-30 11:29:34.802-01	2018-10-30 11:30:03.266-01	2
60	Vilma de Pina	1993-03-16	Bairro Craveiro Lopes	9314112		70001573	167297309	female	reserved	4	Bom	2018-10-26 16:14:59.505-01	2018-11-05 10:48:59.667-01	4
99	Carla Sofia Mendes Tavares	1994-09-06	São Felipe	9578407		384607	138460787	female	hired	\N	\N	2018-10-30 11:44:38.867-01	2018-10-30 11:44:53.577-01	2
102	Janice Claúdia Da Silva Semedo	1994-03-01	Santa Catarina	9146093		402734	140273409	female	hired	3.67000008	Suficiente	2018-10-30 12:08:16.863-01	2018-11-13 12:50:07.386-01	2
68	Paulo Sérgio Centeio Delgado	1984-05-23	Bairro Craveiro Lopes	9751819 / 9384631		137913	113791380	male	internship	3.49000001	Suficiente	2018-10-29 16:50:31.343-01	2018-11-10 12:30:20.059-01	2
91	Wilson Isaias Tavares Oliveira	1996-05-13	Loura	9374314		421833	142183300	male	hired	3.92000008	Suficiente	2018-10-30 11:05:01.345-01	2018-11-13 12:32:30.758-01	2
98	Adilson Moniz Mendes	1996-07-02	Achada Grande Frente	9705545		422517	142251704	male	hired	3.38000011	Suficiente	2018-10-30 11:40:09.868-01	2018-11-13 12:40:56.525-01	2
105	Leandro Gomes Ramalho	1995-03-13	Achadinha	9971273		458703	145870308	male	hired	\N	\N	2018-10-30 12:22:24.242-01	2018-10-30 12:22:52.433-01	2
110	Leandra Helena Gonçalves Correia Semedo	1998-10-25	Achada Grande Frente	5851778		452053	145205304	female	hired	3.69000006	Suficiente	2018-10-30 12:42:31.907-01	2018-11-10 12:07:57.442-01	2
101	Elvis Patrick Dos Santos	1991-11-26	São Felipe	9230618		363735	136373550	male	hired	3.97000003	Suficiente	2018-10-30 12:01:51.809-01	2018-11-10 10:46:45.429-01	2
111	Irlanda De Jesus Mendes Sanches	1981-06-07	Vila Nova	9318165		73849	107384957	female	hired	3.67000008	Suficiente	2018-10-30 12:47:53.563-01	2018-11-07 16:26:52.424-01	2
104	Fredmilson Roberto Frederico Lima	1996-10-18	Achadinha	9859547		418816	141881607	male	hired	\N	\N	2018-10-30 12:19:22.915-01	2018-10-30 12:44:05.825-01	2
109	Eveline Fernandes Monteiro	1996-07-20	São Domingos	9158504		421831	142183105	female	hired	3.67000008	Suficiente	2018-10-30 12:36:45.214-01	2018-11-10 12:18:18.596-01	2
65	Killian Mozer Tavares Barros	1994-07-20	Eugênio Lima	5270088 / 9152175		386521	138652104	male	formation	\N	\N	2018-10-29 16:14:17.647-01	2018-11-05 17:08:27.211-01	2
88	Ailton Moniz Mendes	1999-01-01	Achada Grande Frente	9913141		423321	142332151	male	hired	3.79999995	Suficiente	2018-10-30 10:53:19.009-01	2018-11-07 16:31:13.485-01	2
124	Clenisse Patricia Varela Moreno	1997-10-29	Eugênio Lima	9318775 / 9991970		439214	143921436	female	reserved	4.44000006	Bom	2018-10-31 13:06:01.167-01	2018-10-31 13:28:32.369-01	2
152	Cintia Carine Furtado Parreira	1994-01-16	Ponta d Agua	9746789		380200	138020035	female	registered	\N	\N	2018-11-09 10:24:53.403-01	2018-11-09 10:25:18.3-01	2
113	Évena Luciene Cardoso Varela	1996-05-30	São Domingos	9353799 / 9839552	evenavarela35@gmail.com	423581	14258100	female	hired	3.28999996	Suficiente	2018-10-30 13:14:24.561-01	2018-11-10 11:51:54.534-01	2
117	Ivanilda Gomes Ramos	1993-03-23	Picos	5243763/9586613		401576	140157654	female	reserved	4.03999996	Bom	2018-10-30 17:20:09.845-01	2018-10-31 14:25:42.436-01	5
145	Esmael Correia Alves	1995-11-01	Terra Branca	9921724		403037	140303731	male	formation	\N	\N	2018-11-05 12:03:01.533-01	2018-11-05 17:10:48.139-01	2
153	Natalina Pereira Moniz	1999-09-03	Orgãos	9333880		488230	48823000	female	internship	\N	\N	2018-11-12 10:39:32.061-01	2018-11-12 10:49:41.551-01	2
77	David Carlos De Barros Rodrigues	1988-04-04	Achada Mato	9365912 / 5177393		221433	122143370	male	hired	3.50999999	Suficiente	2018-10-30 09:13:30.815-01	2018-10-30 17:08:41.344-01	2
126	Claudia Margarete Monteiro  Tavares	1991-01-11	São Domingos	9115655		323553	132355302	female	internship	\N	\N	2018-10-31 14:58:24.142-01	2018-10-31 14:59:59.618-01	5
125	Ruben Fernandes Azevedo Camacho	1996-06-06	Bairro	5246616/5162797		452061	145206106	male	formation	\N	\N	2018-10-31 14:49:04.599-01	2018-11-05 17:11:40.229-01	2
140	Ailton Barreto De Sousa	1993-11-23	Terra Branca	5844138		362382	136238200	male	formation	\N	\N	2018-11-02 15:19:31.031-01	2018-11-05 17:12:37.009-01	2
127	Lidia Fernandes Spinola	1984-11-30	Terra Branca	5927935		339847	133984745	female	internship	\N	\N	2018-10-31 15:02:51.033-01	2018-10-31 15:03:44.837-01	5
139	Neisa Ariana Pereira Varela	1997-10-25	São Domingos	9212514		437110	143711008	female	reserved	3.24000001	Suficiente	2018-10-31 17:40:53.769-01	2018-11-05 12:36:30.819-01	2
142	Deirine Sofia Andrade Borges	1991-06-17	Coqueiro	9994773	deirineandrade@gmail.com	345546	134554604	female	reserved	\N	\N	2018-11-02 16:04:24.724-01	2018-11-02 16:06:07.452-01	5
120	Zuleica Rany de Pina da Veiga	1997-12-01	varzea	9166366		431696	143169602	female	reserved	3.6099999	Suficiente	2018-10-30 17:32:15.144-01	2018-11-05 12:41:23.531-01	2
121	Vania Santa Teixeira Mendes	1993-11-01	Fazenda	9938062/9361396		382284	138228450	female	reserved	\N	\N	2018-10-30 17:37:02.691-01	2018-10-30 17:38:50.595-01	5
122	Andreia Salety Garcia	1996-11-30	Palmarejo	9229532		436327	143632701	female	reserved	4.11000013	Bom	2018-10-31 11:44:41.795-01	2018-10-31 12:54:02.349-01	2
143	Adimilson Gomes Sanca	1995-06-20	Pensamento	5211300		422873	142287300	male	registered	\N	\N	2018-11-05 09:50:22.023-01	2018-11-05 09:51:07.532-01	5
123	Bernardina Sadine Semedo Dos Santos	1995-12-06	Eugênio Lima	9158073 / 5965351		397772	139777202	female	reserved	4.53999996	Bom	2018-10-31 12:56:37.938-01	2018-10-31 13:02:58.163-01	2
146	Milcia Larissa Da Rosa Pereira	1999-06-02	Achada Mato	5257560		472859	147285900	female	formation	\N	\N	2018-11-06 10:34:20.392-01	2018-11-06 10:34:26.098-01	2
150	Ivandra Marisa Fonseca Soares	1995-01-26	Terra branca	9168944		403589	140358900	female	registered	\N	\N	2018-11-08 12:39:49.95-01	2018-11-08 12:40:36.375-01	5
147	Jennifer Larise Tavares Silva	1993-07-26	Achada Trás	5219886	jennifersilvala@gmail.com	358623	135862388	female	registered	\N	\N	2018-11-06 12:35:46.138-01	2018-11-06 12:36:00.128-01	2
130	Ronice dos Santos Almeida	1998-02-20	Milho Branco	9279220		484066	148406602	female	reserved	2.91000009	Insuficiente	2018-10-31 15:35:47.953-01	2018-11-05 12:46:29.725-01	5
141	Geicelina da Silva Tavares Semedo	1994-07-26	Ponta d Agua	9333216		417099	141709901	female	reserved	4.30999994	Bom	2018-11-02 15:57:55.024-01	2018-11-05 12:54:07.875-01	5
136	Joceline Patrìcia Lopes	1992-01-11	Bela Vista	9823620/9166566		444859	144485907	female	reserved	3.69000006	Suficiente	2018-10-31 17:24:24.369-01	2018-10-31 17:57:07.057-01	5
133	Neusa Varela Duarte	1991-12-16	Achada Mato	9288214/9571161		345488	134548892	female	reserved	\N	\N	2018-10-31 16:41:44.435-01	2018-10-31 16:43:41.752-01	5
144	Patrick Wagner Sousa Rodrigues	1993-10-03	A.S.A	5814608		385221	138522138	male	formation	\N	\N	2018-11-05 11:04:16.979-01	2018-11-05 11:04:22.072-01	2
138	Aleida  Cristina Fernandes Moreira	1996-06-26	Eugênio Lima	5812547/9748976	Aleidacristina8@gmail.com	422898	142289809	female	reserved	4.76000023	Bom	2018-10-31 17:35:43.438-01	2018-11-05 12:58:31.405-01	5
134	Hélio Edìlio Tavares Varela	1999-08-20	São Domingos	9309222	heliotavares06@gmail.com	470712	147071208	male	reserved	3.67000008	Suficiente	2018-10-31 16:47:26.429-01	2018-11-05 11:22:48.208-01	5
116	Sergio Correia Leal Martins	1982-06-11	São Domingos	9164866		84754	108475450	male	reserved	4.30000019	Bom	2018-10-30 15:37:38.003-01	2018-11-02 09:00:01.579-01	2
137	Yura Patrìcia Vieira Pinto	1997-04-10	A.S.A	9207996		442372	144237202	female	reserved	3.75999999	Suficiente	2018-10-31 17:27:43.4-01	2018-11-02 09:23:02.273-01	5
13	Jaquilina Furtado Da Moura	1994-07-01	Calheta	9274842 / 9134224		384278	138427800	female	internship	\N	\N	2018-10-19 08:53:17.806-01	2018-11-05 14:44:40.198-01	2
149	Gelson Lenito Vaz Lopes	1993-08-23	Eugênio Lima	9302329		395743	139574300	male	hired	3.50999999	Suficiente	2018-11-08 12:19:35.593-01	2018-11-10 12:10:17.252-01	2
132	Ondina Maria Marques Cardoso	1995-01-27	Castelão	9254259	Ondinamarques-27@hotmail.com	385627	138562709	female	formation	3.68000007	Suficiente	2018-10-31 16:36:04.428-01	2018-11-05 11:31:22.387-01	5
112	Elisangela Livramento Dos Reis Borges Semedo	1995-06-03	Lém Cachorro	9775802 / 9225183		417292	141729201	female	hired	4.6500001	Bom	2018-10-30 13:08:17.829-01	2018-11-10 12:20:07.743-01	2
148	João José Martins Dos Reis	1975-06-30	Tira Chapéu	9978303		162250	116225041	male	waiting_formation	\N	\N	2018-11-06 15:41:22.201-01	2018-11-06 17:11:31.41-01	2
131	Cristiana da Cruz  Lopes Èvora	1998-04-05	A.S.A	5267354		489578	148957811	female	reserved	3.46000004	Suficiente	2018-10-31 16:30:12.718-01	2018-11-05 11:58:44.233-01	5
135	Hèlida Suelly Furtado Varela	1996-03-09	São Domingos	9892087	helidafurtado@hotmail.com	425597	142559709	female	reserved	4.25	Bom	2018-10-31 16:55:45.051-01	2018-11-05 15:37:53.379-01	5
119	Jandira Neve dos Santos	1988-03-08	São Pedro	9299862		226337	122633709	female	reserved	4.30000019	Bom	2018-10-30 17:28:31.954-01	2018-11-05 15:40:18.502-01	5
128	Leila da Conceição Cardoso Sequeira	1983-03-26	Zona 4	9268721		64744	106474499	female	reserved	4.28000021	Bom	2018-10-31 15:07:51.388-01	2018-11-05 15:42:39.928-01	2
118	Tatiana Micaela de Pina Veiga	1989-08-12	Varzea	5854713		261937	126193703	female	reserved	4	Bom	2018-10-30 17:25:18.332-01	2018-11-05 15:47:20.373-01	5
151	Jacira Eliane Tavares Pereira	1998-05-01	Vila Nova	9366570		448766	144876604	female	internship	\N	\N	2018-11-09 09:40:42.378-01	2018-11-09 10:11:58.193-01	2
114	Mário Wilson Barbosa Brito	1990-04-21	A.S.A	9921921		325995	132599546	male	hired	4.51999998	Bom	2018-10-30 13:18:44.82-01	2018-11-10 12:21:34.831-01	2
115	Samoel Aníbal Pinto	1988-07-30	A.S.A	5822251		170450	117045004	male	hired	3.66000009	Suficiente	2018-10-30 13:21:37.196-01	2018-11-10 11:45:39.649-01	2
154	Jailsan de Fatima da Veiga Tavares	1984-12-12	Eugênio Lima	9369889	jailsa.daveiga84@gmail.com	180475	118047507	female	registered	\N	\N	2018-11-12 17:25:56.246-01	2018-11-12 17:26:13.385-01	2
155	Hirondina Pereira Lopes	1992-08-18	São Pedro	5243763		307130	130713007	female	internship	\N	\N	2018-11-13 10:34:40.286-01	2018-11-13 10:35:17.061-01	2
156	Evaristo Robalo Mendes	1987-07-27	São Martinho	9222073		225628	122562800	male	registered	\N	\N	2018-11-13 10:49:56.191-01	2018-11-13 10:49:56.191-01	2
157	Evaristo Robalo Mendes	1987-07-27	São Martinho	9222073		225628	122562800	male	formation	\N	\N	2018-11-13 10:49:56.544-01	2018-11-13 10:50:00.99-01	2
158	Yara Sofia Fernandes Mendonça 	1993-12-15	Eugénio Lima 	9322861	yarafernandes14@hotmail.com 	357196	35719666	female	registered	\N	\N	2018-11-13 10:54:41.003-01	2018-11-13 10:56:44.559-01	2
159	Gilmar Antonio Tavares Moreno	1996-01-14	Palmarejo	9551347	gilmaratm14@gmail.com	24468	12446807	male	formation	\N	\N	2018-11-13 10:59:33.918-01	2018-11-13 10:59:41.617-01	2
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session (sid, sess, expire) FROM stdin;
a0c37604-7a9c-4502-b022-367c9a2fb84c	{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"}}	2018-11-14 08:47:05
e900d742-56e1-4fdd-823b-43fb8381e861	{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"passport":{}}	2018-11-14 12:10:14
b9a66cd6-aea6-4d44-b32d-e4027347b957	{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"passport":{}}	2018-11-14 13:04:09
3012f187-2b5d-4e5b-95b1-d9ae946fa40b	{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"passport":{"user":2}}	2018-11-14 15:34:05
b1553270-433f-43c1-9bb3-70ed2f71ba17	{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"passport":{}}	2018-11-13 17:47:57
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, "group", "createdAt", "updatedAt") FROM stdin;
1	Ulisses	$2a$10$qsqNPk0q7/51MSz/FyEx2.u5S5usYTdTg4PhFTb5h2AwsU7BLciJy	admin	2018-10-17 11:35:59.631-01	2018-10-17 11:35:59.631-01
2	Heluneida	$2a$10$RMj46.7gidj0N4Onp9wLM.asKlR9ORAJY1PBvuYkN2092TdkYSDMK	regular	2018-10-17 12:01:17.136-01	2018-10-17 12:01:17.136-01
3	Narciso	$2a$10$op/0GJh9PuWitmai3HmaPuru1FVIBDpht24Xh7.AmRif2AWaAPuU.	regular	2018-10-23 16:02:37.966-01	2018-10-23 16:02:37.966-01
4	Carla	$2a$10$sGYIXpZLpCy5PR3Mt429gedz.oH4zbP6xGJEG3I4E.cD5kMPXPOIe	regular	2018-10-26 16:11:06.517-01	2018-10-26 16:11:06.517-01
5	Yara	$2a$10$1XMms1oEUgy69B7uX3KtwOQzP7a0DRXJJZ9fEZrussWjrC9I8Ue7O	regular	2018-10-26 16:12:07.061-01	2018-10-26 16:12:07.061-01
8	Alita	$2a$10$BBwKABL/G7kCjinSlnVkwOaKYhKaZPCrr0IItYYk8fEZinw1E.Yk6	regular	2018-10-26 16:50:43.882-01	2018-10-26 16:50:43.882-01
\.


--
-- Name: discounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discounts_id_seq', 1, true);


--
-- Name: evaluations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evaluations_id_seq', 167, true);


--
-- Name: formations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formations_id_seq', 2, true);


--
-- Name: increases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.increases_id_seq', 1, false);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 153, true);


--
-- Name: people_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.people_id_seq', 159, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- Name: PersonFormation PersonFormation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PersonFormation"
    ADD CONSTRAINT "PersonFormation_pkey" PRIMARY KEY ("formationId", "personId");


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: evaluations evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (id);


--
-- Name: formations formations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formations
    ADD CONSTRAINT formations_pkey PRIMARY KEY (id);


--
-- Name: increases increases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.increases
    ADD CONSTRAINT increases_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: PersonFormation PersonFormation_formationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PersonFormation"
    ADD CONSTRAINT "PersonFormation_formationId_fkey" FOREIGN KEY ("formationId") REFERENCES public.formations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PersonFormation PersonFormation_personId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PersonFormation"
    ADD CONSTRAINT "PersonFormation_personId_fkey" FOREIGN KEY ("personId") REFERENCES public.people(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: discounts discounts_personId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT "discounts_personId_fkey" FOREIGN KEY ("personId") REFERENCES public.people(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: discounts discounts_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT "discounts_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: evaluations evaluations_personId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT "evaluations_personId_fkey" FOREIGN KEY ("personId") REFERENCES public.people(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: evaluations evaluations_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT "evaluations_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: increases increases_personId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.increases
    ADD CONSTRAINT "increases_personId_fkey" FOREIGN KEY ("personId") REFERENCES public.people(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: increases increases_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.increases
    ADD CONSTRAINT "increases_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: payments payments_personId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT "payments_personId_fkey" FOREIGN KEY ("personId") REFERENCES public.people(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: people people_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT "people_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

