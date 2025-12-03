--
-- PostgreSQL database dump
--

\restrict gaL3OF3hVAXo1K4Tbkhf0FddcUUiv0cfx7U5qbfWBQQ07VNYYifAU7ryOXjdDW7

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-03 06:29:26

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: skills_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO skills_user;

--
-- TOC entry 866 (class 1247 OID 16750)
-- Name: person_project_assignment_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.person_project_assignment_status_enum AS ENUM (
    'Requested',
    'Approved',
    'Canceled'
);


ALTER TYPE public.person_project_assignment_status_enum OWNER TO postgres;

--
-- TOC entry 869 (class 1247 OID 16758)
-- Name: person_skill_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.person_skill_status_enum AS ENUM (
    'Requested',
    'Approved',
    'Canceled'
);


ALTER TYPE public.person_skill_status_enum OWNER TO postgres;

--
-- TOC entry 872 (class 1247 OID 16766)
-- Name: project_skill_required_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.project_skill_required_status_enum AS ENUM (
    'Approved',
    'Canceled'
);


ALTER TYPE public.project_skill_required_status_enum OWNER TO postgres;

--
-- TOC entry 875 (class 1247 OID 16772)
-- Name: project_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.project_status_enum AS ENUM (
    'Approved',
    'Canceled'
);


ALTER TYPE public.project_status_enum OWNER TO postgres;

--
-- TOC entry 878 (class 1247 OID 16778)
-- Name: skill_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.skill_status_enum AS ENUM (
    'Approved',
    'Canceled'
);


ALTER TYPE public.skill_status_enum OWNER TO postgres;

--
-- TOC entry 881 (class 1247 OID 16784)
-- Name: skill_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.skill_type_enum AS ENUM (
    'Knowledge',
    'Experience',
    'Technology',
    'Other'
);


ALTER TYPE public.skill_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16793)
-- Name: organization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization (
    organization_id integer NOT NULL,
    organization_name character varying(255) NOT NULL,
    organization_manager_person_id integer
);


ALTER TABLE public.organization OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16798)
-- Name: organization_organization_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organization_organization_id_seq OWNER TO postgres;

--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 220
-- Name: organization_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_organization_id_seq OWNED BY public.organization.organization_id;


--
-- TOC entry 221 (class 1259 OID 16799)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    person_id integer NOT NULL,
    person_name character varying(255) NOT NULL,
    manager_person_id integer,
    member_of_organization_id integer,
    is_admin boolean DEFAULT false,
    role character varying(20),
    password text,
    username character varying(50)
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16807)
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.person_person_id_seq OWNER TO postgres;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 222
-- Name: person_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_person_id_seq OWNED BY public.person.person_id;


--
-- TOC entry 223 (class 1259 OID 16808)
-- Name: person_project_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_project_assignment (
    person_id integer NOT NULL,
    project_id integer NOT NULL,
    status public.person_project_assignment_status_enum NOT NULL
);


ALTER TABLE public.person_project_assignment OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16814)
-- Name: person_skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_skill (
    person_id integer NOT NULL,
    skill_id integer NOT NULL,
    status public.person_skill_status_enum NOT NULL,
    level character varying(50),
    years integer,
    frequency character varying(50),
    notes text,
    requested_at timestamp without time zone
);


ALTER TABLE public.person_skill OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16822)
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    project_id integer NOT NULL,
    project_name character varying(255) NOT NULL,
    status public.project_status_enum NOT NULL,
    project_owning_organization_id integer NOT NULL,
    project_start_date date,
    project_end_date date
);


ALTER TABLE public.project OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16829)
-- Name: project_project_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.project_project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_project_id_seq OWNER TO postgres;

--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 226
-- Name: project_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.project_project_id_seq OWNED BY public.project.project_id;


--
-- TOC entry 227 (class 1259 OID 16830)
-- Name: project_skill_required; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_skill_required (
    project_id integer NOT NULL,
    skill_id integer NOT NULL,
    status public.project_skill_required_status_enum NOT NULL
);


ALTER TABLE public.project_skill_required OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16836)
-- Name: skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skill (
    skill_id integer NOT NULL,
    skill_name character varying(255) NOT NULL,
    status public.skill_status_enum NOT NULL,
    skill_type public.skill_type_enum NOT NULL
);


ALTER TABLE public.skill OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16953)
-- Name: skill_request; Type: TABLE; Schema: public; Owner: skills_user
--

CREATE TABLE public.skill_request (
    request_id integer NOT NULL,
    requested_by integer NOT NULL,
    skill_name character varying(255) NOT NULL,
    skill_type public.skill_type_enum NOT NULL,
    justification text,
    status public.person_skill_status_enum DEFAULT 'Requested'::public.person_skill_status_enum NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    resolved_at timestamp without time zone,
    resolved_by integer,
    resolution_notes text,
    created_skill_id integer
);


ALTER TABLE public.skill_request OWNER TO skills_user;

--
-- TOC entry 232 (class 1259 OID 16952)
-- Name: skill_request_request_id_seq; Type: SEQUENCE; Schema: public; Owner: skills_user
--

CREATE SEQUENCE public.skill_request_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skill_request_request_id_seq OWNER TO skills_user;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 232
-- Name: skill_request_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skills_user
--

ALTER SEQUENCE public.skill_request_request_id_seq OWNED BY public.skill_request.request_id;


--
-- TOC entry 229 (class 1259 OID 16843)
-- Name: skill_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skill_skill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skill_skill_id_seq OWNER TO postgres;

--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 229
-- Name: skill_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skill_skill_id_seq OWNED BY public.skill.skill_id;


--
-- TOC entry 230 (class 1259 OID 16844)
-- Name: team_high_value_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_high_value_skills (
    id integer NOT NULL,
    team_id integer NOT NULL,
    skill_id integer NOT NULL,
    priority character varying(20) DEFAULT 'High'::character varying,
    notes text,
    assigned_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.team_high_value_skills OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16854)
-- Name: team_high_value_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_high_value_skills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_high_value_skills_id_seq OWNER TO postgres;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 231
-- Name: team_high_value_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_high_value_skills_id_seq OWNED BY public.team_high_value_skills.id;


--
-- TOC entry 4915 (class 2604 OID 16855)
-- Name: organization organization_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization ALTER COLUMN organization_id SET DEFAULT nextval('public.organization_organization_id_seq'::regclass);


--
-- TOC entry 4916 (class 2604 OID 16856)
-- Name: person person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person ALTER COLUMN person_id SET DEFAULT nextval('public.person_person_id_seq'::regclass);


--
-- TOC entry 4918 (class 2604 OID 16857)
-- Name: project project_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project ALTER COLUMN project_id SET DEFAULT nextval('public.project_project_id_seq'::regclass);


--
-- TOC entry 4919 (class 2604 OID 16858)
-- Name: skill skill_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill ALTER COLUMN skill_id SET DEFAULT nextval('public.skill_skill_id_seq'::regclass);


--
-- TOC entry 4923 (class 2604 OID 16956)
-- Name: skill_request request_id; Type: DEFAULT; Schema: public; Owner: skills_user
--

ALTER TABLE ONLY public.skill_request ALTER COLUMN request_id SET DEFAULT nextval('public.skill_request_request_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 16859)
-- Name: team_high_value_skills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_high_value_skills ALTER COLUMN id SET DEFAULT nextval('public.team_high_value_skills_id_seq'::regclass);


--
-- TOC entry 5113 (class 0 OID 16793)
-- Dependencies: 219
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization (organization_id, organization_name, organization_manager_person_id) FROM stdin;
1	Distribution Engineering	110
2	IT Support Services	190
3	Architecture	391
4	Platforms	712
5	Quality Assurance	934
6	Resourcing	987
7	Workforce Planning	988
\.


--
-- TOC entry 5115 (class 0 OID 16799)
-- Dependencies: 221
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (person_id, person_name, manager_person_id, member_of_organization_id, is_admin, role, password, username) FROM stdin;
41	Luisa Booker	48	1	f	employee	$2b$10$vgrEGhsm5ACV66goaNJEV.vEFg43ovsISbIozKWrtmwd8XY.GzYqa	luisa.booker
42	Dominik Cole	48	1	f	employee	$2b$10$QD2HUWXl6Z.QlRgThmx53e4PEOYFOSkK4fMJnQYIma2ka0NzrNWem	dominik.cole
44	Aries Watts	48	1	f	employee	$2b$10$ilxosQMbbgOk.tiOyFTxseH5c6SqP5xM7qqPu5cOnNm/SHh4b8TkS	aries.watts
48	Blaine Best	110	1	f	manager	$2b$10$y/DUM/H7c4okPVQDJy/Iruh1BIQ/YR9kD9757TsUxEqT5kop/rlU6	blaine.best
50	Dustin Hill	53	1	f	employee	$2b$10$/hBx/j.UGQG0ekQqdT3F3e49zaKa/Vf5to98SDJzOV0B0z7.X6wH2	dustin.hill
52	Ambrose Chen	53	1	f	employee	$2b$10$sre/6UMKqQLug9dM.Agp/.OAktd0/xnHCTmi4vcyXHHk1/7TrsVly	ambrose.chen
53	Valeria Stephenson	110	1	f	manager	$2b$10$asfJLKaLguvRE/Q0gyHg/uh3NtAIKYZO0hlLR77Hfd5XFIth4t8ci	valeria.stephenson
55	Finley Wise	72	1	f	employee	$2b$10$IZnEz9/wocMpXGNJmSx6/Off74WGdCJddx9UF/mf09GLdb6ugoTr.	finley.wise
57	Quinn Hunter	72	1	f	employee	$2b$10$MJnaCJ8n/BEBBes/WubfiuyJHTL1b/LtPBnDYg.XHPvDSPZDKBTYq	quinn.hunter
59	Zoe Hudson	72	1	f	employee	$2b$10$qljk9wofs3z6rJ6RaA74wuwgOMusAxi0z5ixVHN488LHxy0KUhrZC	zoe.hudson
61	Presley Klein	72	1	f	employee	$2b$10$FTwDrzz9VeLHJdoexM7ZjOUnBAW.IxN07ffk2DwiuS9iZziW1upky	presley.klein
62	Marco Baker	72	1	f	employee	$2b$10$gfg4.QnZQSJ5DdJqHh96y.P2TJTOm7gbIbDK6icFMzB78mW8KGRo6	marco.baker
64	Mathias Burke	72	1	f	employee	$2b$10$bDHTRmkz9E6lR.K2Yw/2X.ViCI1swid6cE/C5bpjT7TarWGgdHS2.	mathias.burke
66	Jagger Rodgers	72	1	f	employee	$2b$10$FYZGcAtSaPpaWgP/mR7lkezHHLAgwRVmfxAikXcbCUA/AVFyJ8T0C	jagger.rodgers
68	Edward Wagner	72	1	f	employee	$2b$10$srSwmILXO2fnqXfsqf1dmObt7/wHef2h5P7aKBNOzCS81vAyzf8c2	edward.wagner
70	Nikolas Gregory	72	1	f	employee	$2b$10$5GsJWRUtHFjOqEFzavxK5uA47a67ejwKhGv5tDKYPIJOdjMGwrQy2	nikolas.gregory
936	Jaxson Wood	943	6	f	employee	$2b$10$hf3FR2XWxMH2upgX.nIXWe2cZ7YKjIStYZpCANNqEKilh/4.zUv9W	jaxson.wood
73	Zainab Parker	81	1	f	employee	$2b$10$38gOUL5EbO3RJJxRhrMtL.DRx./P45DMYoeVQp.SMbvcorELlZXU.	zainab.parker
75	Kamiyah Clements	81	1	f	employee	$2b$10$WRVX2LHj7lzL86BBxJV.p.RpjiPZZNZ8o.qpTYlX5K0yxGqRkA1.S	kamiyah.clements
77	Janelle Tucker	81	1	f	employee	$2b$10$37MTb9oV0RWObMhrKC.bK.OzWVFc8lCGx.i8m2cArKH9kXFHYP4f6	janelle.tucker
78	Ivan Brandt	81	1	f	employee	$2b$10$uwjmbuJ5gvuJw08eebGjUOPYr9eaqFsXls6Y9MK3N.rKQs0l7u5ea	ivan.brandt
80	Dario Gregory	81	1	f	employee	$2b$10$qEy3b1366N30yrFTfBMKm.ubehUfclRkUW1T9EMNfgh8wXvAL7Uwm	dario.gregory
82	Peyton Garza	84	1	f	employee	$2b$10$uPRKct6oE1nNB73Pclabne.LUiO0NFwN42MTV.WwzkADUQk5UXDn6	peyton.garza
84	Colson Ramirez	110	1	f	manager	$2b$10$e8Teq/qHObxm3thuGkiUkewbhFk..CK.Sa1.Chl5aolfECYG/8k5u	colson.ramirez
86	Rio Good	92	1	f	employee	$2b$10$4yepFOR0ah1ZVlTiuhuhO.QvHunYkPthmJ3LghbLzxCLWBrlqd2ga	rio.good
87	Nathalia Truong	92	1	f	employee	$2b$10$09F4ExaClr4ZtRjq6t/NpuuOcBI3fLlxal1l2Gz6kc/y3qXoXeCqe	nathalia.truong
89	Emelia Blevins	92	1	f	employee	$2b$10$CjRLN8yBWItAibZ5Y9R4MO5Di06hDSCi/CV19y7AA5WEkFRB.gdOa	emelia.blevins
91	Yasmin Rush	92	1	f	employee	$2b$10$/dYP5Is0Lg4MwoWt5N4gL.kCwRTKdvRBT/NKBygpxSwhForzQ5HIi	yasmin.rush
93	Anne Colon	110	1	f	employee	$2b$10$7j3BUW4qKCOsZ1beiadTf.IM5H.M5uWMCQCHZNh29WrcSVHqlwXSK	anne.colon
95	Kallie Le	110	1	f	employee	$2b$10$HwV/Z98av6a1nI92LA2iAOIZ1Jyx6pI8.VyGMFS4aWJ47A9WobY3O	kallie.le
97	Waverly Pineda	110	1	f	employee	$2b$10$DmRwJtX9Kbxb.olPAkX1FObiELtMx0HlfiPhN3K1HCUEKPwMnVMRG	waverly.pineda
99	Ainhoa Holt	110	1	f	employee	$2b$10$xse3qu/m4AVn7KeZaTH1BeKqzHpqhkZ1kpzFd.RK.L7q3a5KcpI9.	ainhoa.holt
101	Jemma Reyes	110	1	f	employee	$2b$10$Bj6xlKi9KybuuaQlHv15DO1Sf/IGTp06LU71Zqi4nLsNt2HK4rooe	jemma.reyes
102	Eli Wilcox	110	1	f	employee	$2b$10$nkzGd/W.TQOBlQXcYT6MceLBP4ey8/0py6xUuT9pEDQ2M0JT.QC4u	eli.wilcox
104	Caden Pollard	110	1	f	employee	$2b$10$WRwEhrFM.1YpFIbnMdDdxu68S3ctP/.HEkIOi5iXNs9.BPKyVW5QG	caden.pollard
106	Gary Howell	110	1	f	employee	$2b$10$QFq7xXe34MVz/ufqFeuef.bNzzRlV0BrBCW2JysXoIKrrpnwtum96	gary.howell
108	Remington Burton	110	1	f	employee	$2b$10$mYZIxOHO9eK.ERQ9z2D0jetYU36vUz7i/3L0P30nTYWS6TjDrOsD6	remington.burton
110	Mylo Hobbs	988	1	f	manager	$2b$10$Kgf7UtdpdneD5ZlePKpuT.B91xhrzpk2yL76rBi2XQJ5EBVfexxaW	mylo.hobbs
112	Jack Gonzales	117	2	f	employee	$2b$10$/BmIJDUBq6k8BO2g/iLM/OG99LDqsncvy4bSLMtE20nqGn6zoiElq	jack.gonzales
114	Nova Holt	117	2	f	employee	$2b$10$hdo4xiV6ocWeQpMcA/RdS.9Sj//ChaZj7nh4JamjShsPJ6sEbt74m	nova.holt
116	Wes McIntosh	117	2	f	employee	$2b$10$ATlVYoz5UR.ogzAEyVPXwOMHtG/xa7SB5FHai6SOlYvwOOYvuJV8O	wes.mcintosh
117	Gwen Dudley	190	2	f	manager	$2b$10$sLIadHKqyaZgOhdd7GasEesdarzDE4yPqCsmdZOofZmuE1vy0hFHW	gwen.dudley
119	Amaya Bernard	123	2	f	employee	$2b$10$Pnpwldn/cD2ItlNa8hLD0./GwQwTgNKgh8rCe6GTLDy2vO9ksA94.	amaya.bernard
121	Mavis Hamilton	123	2	f	employee	$2b$10$BJfin6aTXGPOLuFmPEYUZuWuJEoh0FSR2VhORn2x4ED/nolvIBFMi	mavis.hamilton
123	Azalea Stout	190	2	f	manager	$2b$10$N2mmGtlzIt5QKGuJb2Jr2ePhlOyOckbhC3zCKq7nLBDnN8yxGYbMK	azalea.stout
125	Rebekah Underwood	130	2	f	employee	$2b$10$oAP.M8VHVaJu.trmw1CkXOaL5kPRvyfkSb/r1davKhR/nB/72JOdO	rebekah.underwood
126	Reece Medrano	130	2	f	employee	$2b$10$CBlJprsmsplaQRdZgk5edelAcLJhLATVKbxhSAwIfBCR0nnQ0MH1m	reece.medrano
128	Russell Cunningham	130	2	f	employee	$2b$10$v36twphSqaYxJPg16HrpN.ef6YhlDQJ4IZ7i06BNIiIcjXtAQty3G	russell.cunningham
130	Josue Conrad	190	2	f	manager	$2b$10$HWwbW2qlVJ2VJcKzpLF63eJNqkoRaVpsbwGwpzeyHo2SlR/oRUU3C	josue.conrad
132	Ben Matthews	137	2	f	employee	$2b$10$VT5M9PMA3b2Y.nsdujCoyusf8sZJJy2a73uModhlzix5yXHERVU8i	ben.matthews
134	Jamari Jordan	137	2	f	employee	$2b$10$KNQ8xh20m8bi3V.kvWUYt.0NhY0CiisyLeZZYWpvu9PrEHzhwtjwu	jamari.jordan
136	Jace Jensen	137	2	f	employee	$2b$10$Tq8VyNyI8h33ON6E79DGbebAkWzIzW4hM.vZyQwjoYEsVPjm6M/Vq	jace.jensen
139	Aviana Montoya	148	2	f	employee	$2b$10$h4Mqs.l1ElSCAtJdze9Uee2Z2VhqNjBkH67kOPCgNEZmojva.j9G.	aviana.montoya
141	Nevaeh Felix	148	2	f	employee	$2b$10$1Xi0oBxQ/bF/8i9IdDMvROQ2oTORoC3WaiThPOipir68gJRufavj.	nevaeh.felix
143	Aya Day	148	2	f	employee	$2b$10$g.N8ZWGdyVqXIFhT.CHw1.whjwuE41mKrcnLlYTHSAVCeQzP6IKPq	aya.day
144	Kayson Lindsey	148	2	f	employee	$2b$10$1goIHFjsjnHv4kjWs9veFOwgWYXFn5WN4F9ncJAd28.EzikSvxmry	kayson.lindsey
146	Gordon Reeves	148	2	f	employee	$2b$10$bSM1XOl1qrRg7Q9jLHwDouA3ZhwYiSS9k74NvxJCLv46thdnbluDG	gordon.reeves
148	Dilan Cuevas	190	2	f	manager	$2b$10$TywgUOx9v1FPFzhRXi0nr.8OxRR298Q49PUv0z7Cyqlws/owc7.Ka	dilan.cuevas
150	Gabriel Huang	157	2	f	employee	$2b$10$O7A7jLWvOEB4LjVgTJ/mz.NSQ/jt.YYv6wvECvI1PQZQilq6EXA..	gabriel.huang
152	Baker Fowler	157	2	f	employee	$2b$10$oz7LQFZ8Ne0/oh8nY4OFLe9h/2WxGWy4GNFrloz4m0dHwxAjWuiKe	baker.fowler
154	Marcellus Maxwell	157	2	f	employee	$2b$10$oFfzkWwsopxJOEJvO2D//.jdouK/YACfgFAnFXKmYmre3aCLJvmT6	marcellus.maxwell
155	Kyla Briggs	157	2	f	employee	$2b$10$Vj/UT3mchi6sfL97Vo.2Kua7rob7k4dwwJtu42gn4iHrU09CJU51G	kyla.briggs
157	Phoebe Santiago	190	2	f	manager	$2b$10$tOH9HvaNTlPrfaJxQmxC8u.eU.c9/GcDsjtFnq9B6bx5seO3g/MVy	phoebe.santiago
159	Joanna Mathis	162	2	f	employee	$2b$10$Sz3ke1W8S9gMA8627yXyley62ez6WoGZiJHfyOD7YA.SnYwy3BEd2	joanna.mathis
161	Maren Giles	162	2	f	employee	$2b$10$TLk1GB6hDk85BQFrCUvcg.HN7xL/ZkpV8TJ5vcbhOR3EfVIHZ9nSK	maren.giles
162	Kole Ho	190	2	f	manager	$2b$10$yBCraI49ycnR2t1k1viXBuXS6GnBov5Jxxs67Luq8j5G6l47h8diC	kole.ho
164	Isaac Mann	181	2	f	employee	$2b$10$t5/Tr7VNOsQWO4mg7dLDQuJkc4i5dXn6CnHDmpsnHS46yXxyutg3a	isaac.mann
166	Kayson Tucker	181	2	f	employee	$2b$10$ebIDh07/vJzK4Z657jbQRumPmgNZ1viZ.VAy.Zi2qXQyKBqlCpwxu	kayson.tucker
168	Callum Morton	181	2	f	employee	$2b$10$geKCFcnxuY8bailqE.gRt.lbJAo.aanlXaYj41WkCKfPpQ2lOBqpG	callum.morton
170	Vance Alvarez	181	2	f	employee	$2b$10$lNAakrqq/2yR4LDQcFCADumx.M8YtHXK99yTpTub3v8fj0mzOFEE.	vance.alvarez
172	Harvey Eaton	181	2	f	employee	$2b$10$ZQCmogNU/R/3sXMGBpqVROAWNmwEjBnsRFcHjDuuwHiM2x1DOcvCe	harvey.eaton
174	Bowen Salazar	181	2	f	employee	$2b$10$luyziZYa/Hc2kDn0RvkdDupqUzks1EliC/xpX8KQqEp0/k9zQFlmS	bowen.salazar
176	Corey Dudley	181	2	f	employee	$2b$10$hH1Fwck.IppQyG2Ddfk8luauJY68c3k08zf7TJAMj2VJNNlfK1Hui	corey.dudley
177	Hadleigh Beasley	181	2	f	employee	$2b$10$tCvyU6gwuZXton/SzRZdz.wLFbRM/pUBhgBbYAzPLpY3mYyliO5A6	hadleigh.beasley
179	Ainhoa Cox	181	2	f	employee	$2b$10$X7SiCXARGeDnfPJOH.1Wb.LI4nce1vPScC6OQHuBRuDXa5rrwuXLG	ainhoa.cox
181	Kali Watts	190	2	f	manager	$2b$10$g7i/66yiuT7dtkqVeEFiYutnZy0xAK2ME3aT1gaYQb.YsOl1D2dFi	kali.watts
183	Adalyn Herrera	190	2	f	employee	$2b$10$KOFdqDyLH0.dyJ3b4ThAo.l89ss6YhTKsd.lOrBoBuFda7jwZRRcK	adalyn.herrera
185	Rosalie White	190	2	f	employee	$2b$10$mB3PtqZhRjSo1RGKbIc45.aq2dn5oGm6kqBDEs93fJ0B64f9gJ2Pu	rosalie.white
186	Aiden Miller	190	2	f	employee	$2b$10$7rmFDb6K/JicADl9FQFzrufFc7jcljvCBTM07rSi.42f7QFZu1drS	aiden.miller
188	Beckett Bass	190	2	f	employee	$2b$10$1XLk.5uWcstrPL9cJd7w5.zS48OtMA0.p4YTXLZd9.cb8wLYfwTR2	beckett.bass
190	Moises Castillo	988	2	f	manager	$2b$10$LX13azH/CKaJm5DAmUTKPOaibluKsM3Rf4BLgpd137mCTcVQc3fnq	moises.castillo
192	Stanley Shaffer	193	3	f	employee	$2b$10$tpYCP0b3rg5D15nrKDo1FuRy/nhYlcZFnAm.aZerS9JzfJEy0eQp2	stanley.shaffer
194	Rex Jimenez	201	3	f	employee	$2b$10$7kjhNVMwZpU2N.I4.NrbF.1aag5Aw3nMJ5Ayl0ArRORg2GieFNZWy	rex.jimenez
196	Maximus Perry	201	3	f	employee	$2b$10$FScbYO.cpju9/5QKjVUR3OnFQLf5vg2PWuHx2M4m2hXpGTzIKXRkq	maximus.perry
197	Clara Phan	201	3	f	employee	$2b$10$ANjSTza5/U1nvhlpGssqX.WUKKCKlbYfpvdeUsft9nyiD5CQF3BHK	clara.phan
199	Rowan Barron	201	3	f	employee	$2b$10$mydehQD09eplJutPg8IqTOsxZSEIiZDjuorzPM3rGlEVOYE2xwvK2	rowan.barron
201	Adalynn Watts	391	3	f	manager	$2b$10$aVPYVT7d7JQmBduI1R/9COnhqGnh/esR6a3exrpEYOWVzefXM4QiK	adalynn.watts
203	Jovie McDonald	219	3	f	employee	$2b$10$RhPnSo0g13sL0WW/EpWYzuK/uMgKFY/ts9NDYxioViaf9RuvW40OO	jovie.mcdonald
205	Novalee Arias	219	3	f	employee	$2b$10$iN/aml96r4EijLL2IPDOqeQFV76LRnqBlWHNCTbfDSbU8Lf/fyjPe	novalee.arias
206	Alec Lester	219	3	f	employee	$2b$10$AY2dr7dXpYQ/TtlT4IQFh.Q870reZ/fbe6SAMd93gdqryk.EStcT.	alec.lester
208	Nova Bryan	219	3	f	employee	$2b$10$AeQ65fIdtGPP0kkmptPf1OEgFOA1jPYF1CdbMxT9Qz3sXJ6wFvPvO	nova.bryan
210	Lawson Howell	219	3	f	employee	$2b$10$Ke3s1voRTSpbOjQ5r0S8h.kxPwZO6CoO1eXWw0VKj5eVd24qPqPIu	lawson.howell
212	Quincy Cohen	219	3	f	employee	$2b$10$XpyV1Ku1nRbheHgMfCEsWesqW3z7qRAzMTBYnzfC.4AHEspjA.Cy2	quincy.cohen
214	Abner Dejesus	391	3	f	employee	$2b$10$bY42A.5Vw/14VZzc/Fazr.7P9aCKH7cRrZdsrzwN4bDXfxR43MPR2	abner.dejesus
216	Ray Felix	220	3	f	employee	$2b$10$N2LYmsV4SvBjiJ8qylOoCes0e18aogfS5mfcPpuoAxYRFnfcDLVgm	ray.felix
218	Milo Carroll	220	3	f	employee	$2b$10$tq4mSKcDqAIwAciH675dDOUOHFmluUNx6lJ8etG7M5SAMGXFmf3LS	milo.carroll
219	Zara Kemp	220	3	f	manager	$2b$10$xvmJmBQG195TRqu8WV7CuedwypVHqgg9J0Hzn2Q0mKwzf7YnXRXLO	zara.kemp
221	Raelynn Knox	226	3	f	employee	$2b$10$7IAjTd8mfDDVnXiI49c6Lub0h0nsGNQIVi4U7SMCpJ8XAUwl4LZMi	raelynn.knox
223	Sloan Holloway	226	3	f	employee	$2b$10$16Rl7T1dJF.ID.fAZxHN1eN4VtqdDoNwVZMkNvN.jBepb7SyKslT2	sloan.holloway
224	Sutton Tyler	226	3	f	employee	$2b$10$/U9RQ7H5hPp7tHSyqDDJIeDrG3SkE3luiFM5zG0LHiXL5wFnnjvbG	sutton.tyler
226	Kieran Castillo	391	3	f	manager	$2b$10$5LEG0LtN31m9CHKwBBZHO.t26tWujJQcU7F5hhmFwpHJ/RkYfMswe	kieran.castillo
228	Alistair Avalos	233	3	f	employee	$2b$10$NbWqANGzi9LkKXZykcZ0OeW6tKQZTnkiTdkUjRLmwqhDIaEsnt.0i	alistair.avalos
230	River Lugo	233	3	f	employee	$2b$10$4HZ2iWdsPJ5LcUmW51PTteVu.zMbDuQcYnUogRM.7ridGrCCg1lzy	river.lugo
232	Princeton Mitchell	233	3	f	employee	$2b$10$Ndr6jCJM6bLfqcmIlA5E6uM2Z5cgPj8b3CraHCm3nrROuwiBERfy.	princeton.mitchell
234	Bryson Gallagher	240	3	f	employee	$2b$10$gGEqm3IvaIFjIFxjBuOaCO6Sgw3FsXDNw0fKiz9qAA7UGrC3NNE1C	bryson.gallagher
238	Micah Gonzales	240	3	f	employee	$2b$10$Id.0YOT9BEQaGUgzhiL49uU24Zq7kadz4vUWGoCvLwf0eniB5R1yu	micah.gonzales
240	Tate Strickland	391	3	f	manager	$2b$10$gNDSfcV7Igiv3Wrp2TnDOevYUTWg3BFWjtwcid/GVM1iDvj3FkVyu	tate.strickland
242	Donovan House	251	3	f	employee	$2b$10$oz2eXfgHwHA3yeym/OE4buRzfJ4WcI/BLUCy33Lqci9TjfGVlrrae	donovan.house
244	Kayson Fields	251	3	f	employee	$2b$10$qG7m5lntmZIqzMPYfO3jTuXjnx9v1hdfrtznfl5WepIvcA1vTyuFy	kayson.fields
246	Osiris Dawson	251	3	f	employee	$2b$10$L4dIXR/5WJgd8UiNLHLU7ulg.d6SgtckPA8DmkFibWyCqEotnZv7u	osiris.dawson
248	Jovanni Pruitt	251	3	f	employee	$2b$10$8PGHe.6PqJg7vrqsIiBvgeZ0RVx3fEijCKfnPijCklM28iWZL0jQq	jovanni.pruitt
249	Brylee Valdez	251	3	f	employee	$2b$10$o20a7FltahtK/l.ASqULBepXfVRk4S4Ns8nl0VjpztWN//j7ma7jW	brylee.valdez
251	Baylee Mathews	391	3	f	manager	$2b$10$xTaETsul4darCJFPWLS.WONuwuy51q245EsIWBrZ5vb46k3rKqHAy	baylee.mathews
253	Pearl Woodard	260	3	f	employee	$2b$10$gd7b7iAe3MR4j1UHzctwXu8WuUCkuQtHU.lBpv1sj.5PO6UmRC6KO	pearl.woodard
255	Rosalyn Roy	260	3	f	employee	$2b$10$qkJ5.wg75C/QdI0U.o1bbeMcq98AWs1hvlUqnn8hDJ.Vvn7SHfsnm	rosalyn.roy
257	Esther Wang	260	3	f	employee	$2b$10$FK6wRJvfGcoahxNauZmAZuZVnR2JnuDQ15LBKtGziL3fSSvt4WsMW	esther.wang
259	Madeline Quintana	260	3	f	employee	$2b$10$hX61SMiIQdQiuSTGyBfpjuvE8eunx4WzS7ND87yswF.EPl.XYOrcC	madeline.quintana
261	Regina Castillo	265	3	f	employee	$2b$10$7uEpND0iNRU5a3QEo880JOHXjEVF2DDoxMut1GHZjAv9XNH.gH4CC	regina.castillo
262	Kai Brandt	265	3	f	employee	$2b$10$jjzdrJrCApiAwNcrXpXcWun5ftrHimQ37mXLwaVZKm1L1CNt3dA9G	kai.brandt
264	Miles Moreno	265	3	f	employee	$2b$10$2ggq5KtWZ.Q9Rbm581HvzOauiCeTUIp1bJbfJ.m0oYmlwoQ72DT3O	miles.moreno
266	Jamari Beil	284	3	f	employee	$2b$10$RSf52iFnyxhF2dGiH5Ggre61bXAPFoEFTvJhZyH9Mi2foCAvL65ke	jamari.beil
268	Quinton Colon	284	3	f	employee	$2b$10$R3x..gybQeZbZhcdiduQtuyqJPGqUP1cH5BdVSZo4J.vT65dLrM92	quinton.colon
270	Westin Vasquez	284	3	f	employee	$2b$10$e3avc45sxAX22zEi29YR1uDRpL4oB1qcV0.FKKofSdDUu4isI9mq6	westin.vasquez
272	Abdiel Huynh	284	3	f	employee	$2b$10$oY8oRLdvGQe5xaRDcUXWLedafH058x2hZn0fA3aTVnXghlELlhGVC	abdiel.huynh
273	Oaklee Xiong	284	3	f	employee	$2b$10$LHULV8gbqvBRIU7v4kOC4uHJmmWRHRtjhI0TeNF2V75E1yiyeBq16	oaklee.xiong
275	Katie Costa	284	3	f	employee	$2b$10$mxCTJevpnXUaEw0faer1ZeMbAvmBDsatr7.H8Yap9uYSRcosJsXX.	katie.costa
277	Juliana Poole	284	3	f	employee	$2b$10$oX9950cDv023khHWPL.Mcu1GQCeRMZGL/t3Q8r3U4.raECeHj9A6m	juliana.poole
279	Elisa Gonzales	284	3	f	employee	$2b$10$6TQpBaUEB5yd9II.bV0AN.8h050TyZYhGf9nLOy0j3sYLcTmkBNLm	elisa.gonzales
281	Julie Hardin	284	3	f	employee	$2b$10$ynFkCEsAzRJKBVtpQrNZQ.8ArjnBtIjhCoHHdrrGTblT2SROxvBCC	julie.hardin
282	Hassan Williams	284	3	f	employee	$2b$10$jJvIcL8dOrAX6dvpQUel0exSWY7Ve7Bauu7KbtcNTYuWcOUz8D5a2	hassan.williams
284	Harlan Pugh	391	3	f	manager	$2b$10$Fkdj9FeLvhMdo8e3LgZQF.Wctm2Miq6AwJKY3TYxHvMDvacqIF.Ea	harlan.pugh
286	Peter Vu	293	3	f	employee	$2b$10$m/v/.I7dib7PXTW/U1DBtueKVhT4QlpDLp1O9hWKIZHR9593rVc8u	peter.vu
288	Declan Keith	293	3	f	employee	$2b$10$J/QtBlV4J3zEZleQS7SC9.lq949XLx4oOAQui5hT5VE6qkmZWRq4G	declan.keith
290	Alijah Walls	293	3	f	employee	$2b$10$tv.BvSFJuGY2NyAv7rb4E.hp/VrujVkx2Fe0S8ysMwbiyeSxQDbCq	alijah.walls
292	Hendrix Phan	293	3	f	employee	$2b$10$AvUP3RRBlp/Fue6PKWdNzuVvWwjpV0Iao/YESegSAvySQDSgHe/O6	hendrix.phan
293	Elsa McIntosh	391	3	f	manager	$2b$10$nXScNGXb.vEAwvYeYztVsu1MtqTg4Qims588kOhHTLaqvkVrPiSxu	elsa.mcintosh
295	Katalina Pratt	296	3	f	employee	$2b$10$ONxtAaVJ10KDttvEDUlZgeDgVi2ALR10wKHRopRq3PYjrx.6BZkFu	katalina.pratt
297	Brittany Briggs	304	3	f	employee	$2b$10$QcV20.jX9PWyD48HrE9Lo.kTO8EHVpj/t6vctPZlNxQat/qgh8kJi	brittany.briggs
299	Mae Novak	304	3	f	employee	$2b$10$Lq39x9df3S.sNTIBnkb1c.LstLsar2JdGEir8xG2hZTSsHyR9lwSW	mae.novak
301	Grace Landry	304	3	f	employee	$2b$10$gCWsvYaTOIXTD8E.ZGAY6OEckMzDqzrfhgrzpDACPfIhd8I/mowcy	grace.landry
302	Jaxx Rich	304	3	f	employee	$2b$10$SOq/T2DLIKP0ii7VAc7pKu9Bk90xAcBpxnCN5bKRG9aFjhiPtjaAa	jaxx.rich
304	Alan Hensley	391	3	f	manager	$2b$10$gXOpoJvEwjCwrlzBVan3HeNwmf9IKr7T4Pk0EQYnmfDgoQdZx/AWS	alan.hensley
306	Judah Parsons	322	3	f	employee	$2b$10$/g4qFTefVU8I4qmvNx8OK.UFoqdj73TtEmHytlPdhx3AMz.1FyDBi	judah.parsons
308	Keaton Lin	322	3	f	employee	$2b$10$4Lc3ZeUJTRCrJO91R1HaR..qRmzUlEDr6G21Z92/.D4Aq1Sn0.7ES	keaton.lin
310	Shane Gonzalez	322	3	f	employee	$2b$10$QLdULAyeC..QdVW8gGSewutExg2L9gdetwDu5J6yOFOHuE0ft06He	shane.gonzalez
312	Sebastian Lane	322	3	f	employee	$2b$10$/NEEKAqVZobCo1VgadPm/.h3scE2l6OHWWN/z8gBjBilp9eANu1.6	sebastian.lane
313	Amy Holt	322	3	f	employee	$2b$10$Utjc2lvb5JubARbhn5czbe7tRhW8JkmIp1n0MinBInBIOEauZrmIC	amy.holt
315	Cecelia Payne	322	3	f	employee	$2b$10$mZsBjfw5N22rZU.UI4PeOernVUouEL6Fow4OQ5LfMEX1JyeRLYp52	cecelia.payne
317	Henley O’Donnell	322	3	f	employee	$2b$10$9A9vygYucksOOwxzmRikbedVKS8Ku1mcnE3x6LUh2USNUD1KWYMe.	henley.o’donnell
319	Brynlee Mora	322	3	f	employee	$2b$10$jKTmXeq5RTDr71n1URduN.UY3BEC1vquDU7G5R0yZGbiLW61LLy12	brynlee.mora
321	Ximena Esparza	322	3	f	employee	$2b$10$6s33PV.sP81rWMMj7eJLMemz8Sxc4hbvdSQAniEy8XAfP9Fa6bNei	ximena.esparza
323	Elianna Vance	327	3	f	employee	$2b$10$z6ynFprxKnPRIFF8zLbpA.PL3NdRCBu7MwJma0qYfFQMy2FGSNZji	elianna.vance
325	Kassidy Strickland	327	3	f	employee	$2b$10$hL/ZWRDHAxQAefVtVJHOlu0djiisrTNl1fM82IFP9LuGmx8eODHbS	kassidy.strickland
326	Keegan Lawrence	327	3	f	employee	$2b$10$s8380E7iYMIl/A4NwL.pg.UEfa/0tGuhMMn8CLUAEsuXqKnPC3dxK	keegan.lawrence
328	Angelo Cano	338	3	f	employee	$2b$10$7NQJAB7XsG0Qp9TAjzHG4.fZMLLs/of4XilHVpGTaaqnS2VCKBEPW	angelo.cano
330	Alijah Goodman	338	3	f	employee	$2b$10$Gg5WWN086z.4F3yZJ6kR6.6lzVywcWK/Dtkj/R2UEojZCwWKPSurC	alijah.goodman
332	Kylo McBride	338	3	f	employee	$2b$10$mHP2IPSLNJanxOGWxPCek./vcM5vppjydMLkkWH1Nzl/2MnK41f9u	kylo.mcbride
337	Martha Waller	338	3	f	employee	$2b$10$BSwB0kDACVbaqhgRXYNBm.oBMw0SpDxeMOMQZf7LGh/EFE5U6ZLiq	martha.waller
339	Bailey Maldonado	347	3	f	employee	$2b$10$uHddkjtrQl0W5mSJOy8G2err0Fbdey3GbYhgOXnrz7Fjh6DBbnCAG	bailey.maldonado
341	Alivia Curtis	347	3	f	employee	$2b$10$Zvo3XysLQqJVWE5OsjOsmeU/Lpa9LisZ5PaadHw6ApR2NAeWOp0he	alivia.curtis
343	Ellis Norris	347	3	f	employee	$2b$10$tGWoRTvx4Uc3maOfkBVWFe9UVUuZ1psc8NKTfSsQL/2ysSIAWq/TC	ellis.norris
344	Cairo Hess	347	3	f	employee	$2b$10$yOfaGwAtHJxv2gi/8tVP1OduiwcKST.br2uApD4UdGdqPJL.3MzZK	cairo.hess
346	Eduardo Vaughan	347	3	f	employee	$2b$10$V5HTPxPrqy1P4otDUtFmEOSjQxzW/AsAEEhDiwQrIfh/tjvNJOWk6	eduardo.vaughan
348	Ben Combs	352	3	f	employee	$2b$10$ZJFb9OxNNeAmCa/n1DtdXOhJnYkhf4XMYhWk6MMynvK9uBzsnlWjW	ben.combs
350	Lennon Woodward	352	3	f	employee	$2b$10$GFPB9dm9C8XtoF44fG8IHewWLxJcUfOL3ckyX/llsRCRPAfyO8cq.	lennon.woodward
352	Damari Erickson	391	3	f	manager	$2b$10$gAxRbE4rl/mgU7wYwPKLau3GjhA/Wg.J0A9xAt00dPD05rD6KkQX.	damari.erickson
354	Jaiden Cannon	371	3	f	employee	$2b$10$sAeA706THjdjj83BkP0/XO3uT420s6p9/mFvp5KjEhaj1IRRwD04q	jaiden.cannon
355	Noa Klein	371	3	f	employee	$2b$10$1jo27Jv8bTFo.bfkV3231uGtAIChHwV7RLrW5s.g4axjL95Wmtn/i	noa.klein
357	Ella McCann	371	3	f	employee	$2b$10$oBx3a/HX0ylToEglF3h8vulIr1C.hW.wKS1zW3OGsPxSJdCe1PMCi	ella.mccann
359	Ella Dyer	371	3	f	employee	$2b$10$mHtJREolo70zQ2Ljwdl2Beal2WeopoklVXtH5ofAhDHpd2zS/kxoe	ella.dyer
361	Quinn Mathews	371	3	f	employee	$2b$10$8VhMWnwXKrZv/RFxVUEjEOvLaWmOn/p4jJ4aXxYFKMArihoAi5DIy	quinn.mathews
363	Leighton Hughes	371	3	f	employee	$2b$10$sImPbcG.1Uy3f4rERhHlUun1k.R5onjrCsFRL7HZdhrEilOBZi5V2	leighton.hughes
365	Yaretzi Garza	371	3	f	employee	$2b$10$MNrYu4eNjIoyflssssYUoOQgq4JaUlEGPC3pOzlUqX9XEbxMvfSBq	yaretzi.garza
367	Barbara Donovan	371	3	f	employee	$2b$10$o4dlyMwIhFMRcIk5U1D2veNlW.FaHoesB0KNySBB5b0Dz9o1Ct6HG	barbara.donovan
368	Brayan Newman	371	3	f	employee	$2b$10$uSSVjwUcfPI6/s1e0w8pI.junkhct/2p6odXQlUyFoVxWFH66LZku	brayan.newman
370	Rex Nunez	371	3	f	employee	$2b$10$YZJUMDi/D8kJQRQ/IJPkY.CSbKhTsuh9m8S1hIB1pgVGunbJNuvY2	rex.nunez
372	Luis Gordon	380	3	f	employee	$2b$10$3z94r5TvujM0PG3Ed7FiO.jkWUNdUh2wtblVXvL.ohDSrbjyYNdc.	luis.gordon
374	Damari Reyes	380	3	f	employee	$2b$10$rxPqhJ5IOJ5KoLYZctD.9e5xCW.jw/JqGK58/dFFPc3UoNh.xJSn2	damari.reyes
376	Armani Roy	380	3	f	employee	$2b$10$x87VC2lq/A6K/90ZM1DPuO5CHLec9CDrtVWlsEKzDKz8PO172EFXC	armani.roy
378	Tyson Wong	380	3	f	employee	$2b$10$e.PLg1PC09n7D6FxLDPnKOTq4m77UFOEbp75YCFoC5YEjaFXV9l9G	tyson.wong
379	Adelaide Nielsen	380	3	f	employee	$2b$10$yV5c06wxC.lHBVc/8JADOuwLiKs8aZIwym4.kKnV6VWVvDQ0dN3Am	adelaide.nielsen
381	Annalise Fletcher	383	3	f	employee	$2b$10$ivyTAvASOH23MtVIqwiE9OWyCB0Wbn4PQzZv3AsijnX0xhSmCDq5S	annalise.fletcher
383	Myra Marks	391	3	f	manager	$2b$10$6J98LKpKj8W6aj4F/ZGs/eIV5BYSrBP6WS9U0nf9khmVtI0eIkGx6	myra.marks
385	Colette Lewis	391	3	f	employee	$2b$10$WKJhtjwkU8UqoJitU5WeCuYoPw0sQkA9EMqR3WmndOv0/fHXAXU3.	colette.lewis
387	Rivka Valencia	391	3	f	employee	$2b$10$78YTRkIME4oOD6oWHX4WmOYnYIqgo0k6IkZh1rgz/e5IZKzUaH0/2	rivka.valencia
389	Kaia Butler	391	3	f	employee	$2b$10$FRjQJKEqQec45baAW6xeTegAXbJCOX.C4aqUSRBZ0Yhtq6879h4zi	kaia.butler
391	Kayleigh Duke	988	3	f	manager	$2b$10$xDsCNTbKjU7d71b0LXKri.WHNtEGIcicS96nzS97oNunqQVxEriqG	kayleigh.duke
393	Addilyn Strickland	409	4	f	employee	$2b$10$P4X9KRMX/yyJfIv/QVN2i.lQ6u.wfd8.b6HmtO7wybxpV10sdDREe	addilyn.strickland
395	Berkley Christensen	409	4	f	employee	$2b$10$jeSXmVfYJFAyze69tpwEF.lH3LMkTcYUforlznRSx1bIHriK25Bim	berkley.christensen
396	Gregory Sanchez	409	4	f	employee	$2b$10$hiSnRJsvSDA7638VAbwlref36FcM4lVjdSGgAcDeD8xlFdbSM3NNC	gregory.sanchez
398	Quinton Cortez	409	4	f	employee	$2b$10$8P4lkgMzfcoNKQiVvWJLVutPhlMv1Wnea4oK24fpagGDYV20oHQT2	quinton.cortez
400	Jaime McIntosh	409	4	f	employee	$2b$10$Yw90wfqkr8/8PLL52MMN3e7u65WTDf1KFz7foaL2/VVxd1rHa.MT2	jaime.mcintosh
402	Finnegan Richardson	409	4	f	employee	$2b$10$prBd68a2su8W2OBAPtoRau6UjOEM3sR5L8/EBJyYh8NnhkKwWrRlq	finnegan.richardson
404	Zayd Bullock	409	4	f	employee	$2b$10$62vY.qHkx1X9CT0jTiXNOe7kfvFocrulycEg1j/IM2gg4R7.RXTq2	zayd.bullock
405	Winnie Salinas	409	4	f	employee	$2b$10$MxxpS2nZY.GniRZMTGqg5uM.xGFyBLQAp479zK5bCIQ7KDhCPGKca	winnie.salinas
407	Ainhoa Ross	409	4	f	employee	$2b$10$YMchUJ2TYrV.UHqwRGDW2.MIlcR1U2iMw9OTYdLyaXV/bdPS0AWv2	ainhoa.ross
409	Vienna House	712	4	f	manager	$2b$10$gwAKUzy7gdknY2VyY/SX5.026D6IvcXsv6ip49TMApk1hvpBfXJO.	vienna.house
411	Ainsley Rocha	416	4	f	employee	$2b$10$ZrbU6/hnZ9ZaC8gWGUR1bONJ3ZMbz3vduwU65vqHrdPpgCCuiuWNG	ainsley.rocha
413	Lilith Hensley	416	4	f	employee	$2b$10$TdScTeH6xhyzhaBBnU60BuU6TBIyIMYJA5g.nG1kPbqKQ.ALedQhy	lilith.hensley
415	Natasha Villarreal	416	4	f	employee	$2b$10$cIGvJT7ImvqNzOZ7qcM.cOREEUixLW9OA63Tp9cNcxoSYrxu9f46u	natasha.villarreal
416	Nikolai Mills	712	4	f	manager	$2b$10$RkmA2rB6t7fwoT3Xsf/MOOyeCxYTfaX7AJIwD0S7AsUE8ZZI6QHwu	nikolai.mills
418	Harry Stark	423	4	f	employee	$2b$10$.bcVory/hwjlOXn9VwOnaeImfUS7GFjEkbYHVCEcN0LXSXdvvbhfa	harry.stark
420	Roger Lucero	423	4	f	employee	$2b$10$CjZms0iH7E0YqJK9aN3eAeLAQUVrvox0nvTzmfMsw6iN0qsQiEAwe	roger.lucero
422	Kameron Lucas	423	4	f	employee	$2b$10$1g3.VlwvnkuQrKAakC0vRenI8CLSD7ZS991YNuX/tDpl7mdUQjQYm	kameron.lucas
424	Reid Holloway	430	4	f	employee	$2b$10$xK49XAFmNVJ28ma.bpKC4uAKKAkGPQWetGv4/GjdxIrHebUKS3X7W	reid.holloway
426	Idris Rivas	430	4	f	employee	$2b$10$stjEwkoNQV0s3UYCXCTfpuY0I8OtbMqsqA4LXrY7UjwyD4QSni97K	idris.rivas
428	Remington Santiago	430	4	f	employee	$2b$10$16pHby60aF6MMFa1E/Ux8eI/EKQHn.9SZK0xMQuyuW1.ylzTXsxA.	remington.santiago
430	Davian Harmon	712	4	f	manager	$2b$10$6oss0F4fIXPTG4h6UICeT.iM4Vnnr8gjbSU9A0SxFPXbjc6ObvFUK	davian.harmon
431	Maren Wood	441	4	f	employee	$2b$10$St3nTSFzvIkNiGjJsw/Eh..xg78ls7A46zCPXi31Zq9pJdUeNlVq.	maren.wood
436	Seth Elliott	441	4	f	employee	$2b$10$KB0Y27i3wAUjzdvZ04OGROj8.tqPQF8waC50j6.cQD/FQnC1xpsgS	seth.elliott
438	Raylan Carey	441	4	f	employee	$2b$10$8eX8LdKaAOTL38DTIanUKOR39UmrCXOq4VDh.pRBa6aASlwKiAXOa	raylan.carey
439	Alora Lamb	441	4	f	employee	$2b$10$fSNbdUzkwOWMMdbRI/.68u2z1.yB7gpe/YLj2gncnawYalDC9o6IS	alora.lamb
441	Anya Hurley	712	4	f	manager	$2b$10$n7/5babF4dBCBrJiFTiABeev7m8kFE3FQ3GvpmSOeXIABRVIcF/Vi	anya.hurley
443	Brooke Barr	450	4	f	employee	$2b$10$QF3jFPEkxz60ZQKLJw433eSDOH4.lp2jLk6vxCWlj7r7FTdP49ny6	brooke.barr
445	Maeve Stone	450	4	f	employee	$2b$10$qJAHRfVr8TeqDMzQ9.W7bOUwRThhGyCsfQXCXMB5S4rp4X1afJKje	maeve.stone
447	Coraline Duffy	450	4	f	employee	$2b$10$YYw3cIC/VeC1pkJ9HiVko.2xBdmzhgd6TkoBJD7GFzAKRtJ/nsaqC	coraline.duffy
449	Emmy Vance	450	4	f	employee	$2b$10$yk/dVGqfnMkaLo1jdUYCh.eS1SZMb58SarehvM9eNuqgSHeX7TSOe	emmy.vance
451	Meredith Sexton	455	4	f	employee	$2b$10$inlywaNRQ136GUWa75P.puM3bRdlYFA0lM7Gn3Ul4w7yuFYQb0W72	meredith.sexton
453	Haylee Randolph	455	4	f	employee	$2b$10$bdPXkUY412/LBOZbHi7Waumr/2JdI3TFc7VvEppW4cdLBigXGkzXO	haylee.randolph
455	Ari Camacho	712	4	f	manager	$2b$10$C8lyTHalaLv.3ishbAuitOZq8ZDKf043bBGHjEYTxVhdyc9NT4B2a	ari.camacho
456	Tatum Stokes	474	4	f	employee	$2b$10$vrVFPTQVk89YZDgvSpAVmuQewmzRzb/1zp/H7kqg4DVGU1Un3tr9G	tatum.stokes
458	Jacob Roberts	474	4	f	employee	$2b$10$Lui2GOovaOq3sSNwU1hRW.ZGCpap31dM7Rg2J8vpcduu.rEAqq3oe	jacob.roberts
460	Enoch Ruiz	474	4	f	employee	$2b$10$mm7Lo/V.8v1h9Qu1UyuHh.2dpCVlEqnK4exDw/O9Hu3ZJBPiRbj4W	enoch.ruiz
462	Danny Conway	474	4	f	employee	$2b$10$IWUlH/GOtFXEqzNO1LdtKONCdbwQJ9kDDtc.gOZBGNs/hiF3NHx8.	danny.conway
463	Ryann Le	474	4	f	employee	$2b$10$/EIiwqHc2KcB4WWUc7.dgu7/WAMjDXWf2vnJD8dr7MFB8caXcpdOy	ryann.le
465	Celia Vazquez	474	4	f	employee	$2b$10$BpH5K7UqrKDgQ4G/74cPduYKdEJ7xLSIcKrefSRAz7Z6YC3zCuF6C	celia.vazquez
467	Lila Harrington	474	4	f	employee	$2b$10$26c/V.DsTIMgKFHOMjd2xeYdGQFzg2XcuRfHiqJgXn0wp5oUokbPO	lila.harrington
469	Noelle Clay	474	4	f	employee	$2b$10$4FoIewfQ1mi7Fd2HeyNb0.E.r82Vgi//b6Lc/u.o4LSBFXDrwSmtC	noelle.clay
471	Egypt Jennings	474	4	f	employee	$2b$10$an2cUACadYMvU8JS.RXWYOzVimRYwcT3DlPwDrYqTc6MV/ceDDjSq	egypt.jennings
473	Victoria Sampson	474	4	f	employee	$2b$10$rqEm.M.LA.gUDQojE.IEYuitl1b2m8xD9MzQO1hUZK0.tJXbauhrS	victoria.sampson
475	Maisie Yates	483	4	f	employee	$2b$10$710tvXOeVJ8n7th/wR6jpOqCg01otzg58Cf2feuajq3ODHEImHgzK	maisie.yates
477	Oaklyn Black	483	4	f	employee	$2b$10$1j0yXNHndBLeavoeaeKxD.1NygZml86H7W9rm44tXJaIItHLyWV8y	oaklyn.black
478	Matteo Bernard	483	4	f	employee	$2b$10$typN5IR1CjxbxuQxdiDPCeqgLTvEwCx40/SgscPCiXs.ewws/6ulG	matteo.bernard
480	Korbyn Dickerson	483	4	f	employee	$2b$10$DotN2s3yNYEG8LBnVdHyD.6uMK9m.4/9iOKthqgyLBP8abdUgVt2W	korbyn.dickerson
482	Allen Wolfe	483	4	f	employee	$2b$10$Bb3PSVasOZGd3UYvvHDK7eezhdIYczfs.6cRXVlmsIbyAVLr/KZVK	allen.wolfe
484	Jayce Hunt	486	4	f	employee	$2b$10$hgmdQeHMjVQzF2xy4S.4SOeVQsfnDc8Grxe0ZMk.CnHAzLlOX.MXO	jayce.hunt
486	Gustavo Montgomery	712	4	f	manager	$2b$10$zkldqEysusvllAK9aBWHiermvlF0wjBccFYp191SdumEpcxKLOfpS	gustavo.montgomery
487	Evangeline Stein	494	4	f	employee	$2b$10$vJozzaRDVLH5QsDv2syRMuFrc4gR0Lh1JNBhepHbhiv4HITfIAv36	evangeline.stein
489	Zelda Schaefer	494	4	f	employee	$2b$10$7fAGVbGNZlOqeF8DuNnhi.34BAHODEVEpPgxqgahnOC4DKOlVLne6	zelda.schaefer
491	Remy Tapia	494	4	f	employee	$2b$10$Fuop4LXPGTtBRXHzucPeyuWxMsD/CGWpNPJoiWqlHe2SvJ815SpsG	remy.tapia
493	April Anderson	494	4	f	employee	$2b$10$sXt4gmyK9Vpg1xlw.Vwc1OFB60ctww/n2bqBXTiO9flre73dT.FH6	april.anderson
495	Scout Randolph	501	4	f	employee	$2b$10$PtD9aYV/qrA2qqqy4Cdj7.TIuS0I5CuxT5d4M09hQZWeJU1vamGkG	scout.randolph
497	Julianna Rios	501	4	f	employee	$2b$10$NmkQaW/YnRe9LITAJlzKveBVpuauhLxgY0qodNJHq4xpLKKwcukIC	julianna.rios
499	Laura Garner	501	4	f	employee	$2b$10$Uu2IYn4VVM151x.JJMT7E.iuBqHN/v/pp6gtE1YvGIbJDb1sybbXq	laura.garner
500	Sage Ho	501	4	f	employee	$2b$10$vUja62I2UE5FTFg3HfoOsu6JHBWhOyXoO7rdinSBER0WmUpbdAPme	sage.ho
502	Devon Hayes	507	4	f	employee	$2b$10$FcnZFVKjRxSOVhNQLjwxJOrf9NOs79KBoZZkXzUJNMd.9AvyZiQ9y	devon.hayes
504	Adonis Orozco	507	4	f	employee	$2b$10$y/Vuf/H0WncEbwsgog04geB9MUt6tfMBSeSa42TKAGe3pLD.2Rqma	adonis.orozco
506	Elisha Khan	507	4	f	employee	$2b$10$w1Jdjz3AU3T99ZD3t8AwT.e8yodMxFCE.182bn0XqtKjKTar7Pwre	elisha.khan
508	Nathaniel Faulkner	514	4	f	employee	$2b$10$TJeGFfkGdkh9XCIvn6LLwuJyOyOppWrAK8w7L79nm2b1hTW/PGJu6	nathaniel.faulkner
510	Samson Hubbard	514	4	f	employee	$2b$10$LIRwZoBJSpQb24TSMsAaq.lQq2tLj2wmriSr9CbWHtT8ShcittYaS	samson.hubbard
511	Rosie Reyes	514	4	f	employee	$2b$10$LVEG6mxMYBsqR6idb2wiZOg5o/X.NdkXlzPJVVbj.0FXRJBGcPmDC	rosie.reyes
513	Arianna Hill	514	4	f	employee	$2b$10$E.FYF2cwW1YIpys49DO6GerCku16oO3JQMTUQsi8rNS7Coghb9cZ.	arianna.hill
515	Macie Nava	521	4	f	employee	$2b$10$uKFOIY4JL/SJ9Ye/vSrmjemCBwD75ZN73oOcB/dh36SHkqsJrkeAS	macie.nava
517	Emmaline Harrell	521	4	f	employee	$2b$10$/jug96sTKWyJ3oQWBxLeHuGLVXEtKp3qK399ClE3XmmCBV9R.Lxvq	emmaline.harrell
519	Addilynn Greene	521	4	f	employee	$2b$10$f039p5vL.q.khIcermSmb.HX2nohCqG4kcP0HXiyEEoNkbuQTKrcm	addilynn.greene
521	Addyson Pennington	712	4	f	manager	$2b$10$0A9oVLjOtAavoProzZinlexuzMhBGOUrNut5lghbwiAkYVfDCH.nu	addyson.pennington
522	Bobby Peterson	532	4	f	employee	$2b$10$d53YHJIsMIGX4.OlvxDhxuBCTIy1enKE9h8kG2jF51zg53X6/uF.a	bobby.peterson
524	Barrett Burnett	532	4	f	employee	$2b$10$GrTiyS0FM1FibW/thd.NU.Iaaikzum9oayWfQNm9E1cL4p/rXQFQW	barrett.burnett
526	Jefferson Vance	532	4	f	employee	$2b$10$8hDQzhP/jtWmsuLQoRLiRuKse5o8CqoNiO5zy32vot5.G1sdsf8fi	jefferson.vance
528	Alec Golden	532	4	f	employee	$2b$10$3d04o9rjVCzymy5Pu4n8OOhJht5RIp2yD8trAV4CuABF.wxuAIz66	alec.golden
530	Odin McDowell	532	4	f	employee	$2b$10$PfE.w6bqr1bqB8GcWP5I4ucTvJsrKVh5ooTpNx7rOvnSkyP9Qh5Lm	odin.mcdowell
534	Noe Reynolds	541	4	f	employee	$2b$10$/1AhIzZwITmVdyBUj0dQZed/hj8XSmUNTEh2ABc8Ea2Z0BWfqznRm	noe.reynolds
536	Ford Schaefer	541	4	f	employee	$2b$10$ukdvRTidv08bmaLyMq7o0eCCF1zcUDL4UDG/dyxn5ljxC8jzZ5/Ae	ford.schaefer
538	Arian Spencer	541	4	f	employee	$2b$10$EJiLAElM.ZN6lbjrKrKJVekDqqVDqjI3zLc3BtzXm0NYCI622wNqu	arian.spencer
540	Kody Mills	541	4	f	employee	$2b$10$iZ6HM4SvmcJwNbcu77U2WOyGQR//nAWh8E/flp2aIhbcYfKVEeCki	kody.mills
542	Orlando Hester	546	4	f	employee	$2b$10$Q8SFnSIYxVYE0ul3wfgwPOejRkxE8b567FDCidKeKVm7EyWQ9vt1C	orlando.hester
544	Kyree Weber	546	4	f	employee	$2b$10$cvOOXsp8eTYxnh..MY5U4OKVSkLuRMSLeCtPCYT3cvAehv/szUvDy	kyree.weber
546	Greyson Mathis	712	4	f	manager	$2b$10$fylwApN1qfcBUkDlXvhkruLVjRPFnWY9aXHYK/n/O2HI9ZHV/DtXe	greyson.mathis
547	Anne Gallegos	565	4	f	employee	$2b$10$BaM7iVqevzzdgNnKamIyqu/a7/h52sL8Beue9vARMv/mZAiaQjAbu	anne.gallegos
549	Makenzie Nash	565	4	f	employee	$2b$10$y7PIjxesV0ExxwaGukg7dOHhwZeUvpnA9cFXIBlBMtTeUsxvkPaeW	makenzie.nash
551	Royalty Lim	565	4	f	employee	$2b$10$kDixU04FygD.Kctd39AvreNhryu.12xWE.zvO1E0mbqrpsJhOjOUW	royalty.lim
553	Celine Calhoun	565	4	f	employee	$2b$10$Z90XL4gxDuuMjYrwV7rvLe4y8lpey5iZUcp9ndOJza3j5m3XSXBtu	celine.calhoun
555	Eileen Clark	565	4	f	employee	$2b$10$hfDf5WZC64QYlILY7zMSvuQU4IsjEFzo2trteZJ9WToWcm7JXNpxe	eileen.clark
556	John Palmer	565	4	f	employee	$2b$10$xNL8Btpmszhv7tONjnUTV.YBBr5Y3ZWHfb/.a2KT.Cn/yeEMUCe1G	john.palmer
558	Branson Lu	565	4	f	employee	$2b$10$Sd4tCfNeCkdaBzsugLLge.CEpqqX45HfchpcIxm94nC1rVAhQSWmO	branson.lu
560	Jovanni Ferguson	565	4	f	employee	$2b$10$nYjMJaWzlDy/Sry/idsYouCnXEHr55.CuZSe2b8jHKeJEOltLDTpG	jovanni.ferguson
562	Jaxx Webster	565	4	f	employee	$2b$10$TjrFKnAYk4x5Z1aKsCoHvuWxoUVNiwps6KLlZ2ILCQkKxzS4Pv.VC	jaxx.webster
564	Jon Garcia	565	4	f	employee	$2b$10$SRZDsP229tNNHOUBra7vkONsVDOD0BOgTILUCJwR2PZKimV77LwxS	jon.garcia
565	Amelia Coffey	712	4	f	manager	$2b$10$yI/4rq0.Ppc4FUm6kZZXZOBcScn2W/jUm7DlQstDptVVpLtlJg0x6	amelia.coffey
567	Lily Callahan	574	4	f	employee	$2b$10$qNdyP1cTctjMim4GoUuGIuf57BHm5I9H4nfUpenIooDqyHmqs4I8W	lily.callahan
569	Madison Marquez	574	4	f	employee	$2b$10$qw.MEHYSnHLJYwAvR1PuvOMTSe5SuuAI2qlRl4LNY1nTDnF6fMAnm	madison.marquez
571	Samara Rios	574	4	f	employee	$2b$10$OX1RHCa8lNyLiALoyuvjwuzP5eTMI3JInWW5zDRLjLplRjyjUGPBy	samara.rios
573	Leanna Garner	574	4	f	employee	$2b$10$shdEef4bv4pFrnbx7FYQ9u8KRG6vhGApaHRNs9RIIlhjo5Luk.rpi	leanna.garner
575	Marianna Phillips	577	4	f	employee	$2b$10$PG0O2X.xetwkJhyfsdTRc.cBbYEQdnz0KnEGvoBTovnFYY7WonHBS	marianna.phillips
577	Alaia Carey	712	4	f	manager	$2b$10$H1mA.KszEkvBW.7DoGxiNuP9upXLsQ/oft1MK7BnR2Dp6UoR13yOK	alaia.carey
579	Catherine Bauer	585	4	f	employee	$2b$10$pwWdrbk8E/ZVORr/Zvowte9ktYCDHAyqhhlnoSLu2KfIFQoBVk2Xy	catherine.bauer
580	Kieran Cunningham	585	4	f	employee	$2b$10$Z8rvrrRDGnC7NJsSBZdAs.SHEAMwdb0VoYdQOcxTUPOuR7rl5SlKy	kieran.cunningham
582	Travis Richards	585	4	f	employee	$2b$10$UbWuFB/PLM.0aqsBwnLYx.uAnUXHd3KLja5IgfP/aZS8O3XHxXXQy	travis.richards
584	Bruce Li	585	4	f	employee	$2b$10$p7xqbtC606JFKIBl/kPwSOTX65.M2MbZ6LzvQllXa7oJzLY0qSYj2	bruce.li
586	Avery Weaver	603	4	f	employee	$2b$10$teiO3NoqY6Wo1zBUSRIR8.kwtTNi6XZrICRmwfAjip1xZ.Ig2D5ya	avery.weaver
587	Teagan Rosas	603	4	f	employee	$2b$10$svF3A203jNCuacqbpetETe3tIBkZBmflPZSyxZGkhA1NQCg5zFxlq	teagan.rosas
589	Nathalie Stanley	603	4	f	employee	$2b$10$qZA61G0h/eSKfUOaEOv1YOWf5PrfgldhtO81cwJzjfQDUWnEXKhi6	nathalie.stanley
591	Noemi Peterson	603	4	f	employee	$2b$10$9Px24E19Kj0edKcK3oS5AuClL4KEHKAmkBj//aeG9hcwsqCg/lIgq	noemi.peterson
593	Reagan Pena	603	4	f	employee	$2b$10$GmqYGeMUJkFTNRyavqgyGO.ekNR0YGExnKoPfNYpRr92pRZiSl5d6	reagan.pena
595	Zendaya Sutton	603	4	f	employee	$2b$10$.EIoMzRTH86565VOS8NalOVW/jK77v5dhYgGu4hOh9FFxO/Dhhfji	zendaya.sutton
596	Warren Calderon	603	4	f	employee	$2b$10$b5I0er9dsIjJZLujcgoppuci1VcPvsDGLezPD9b1zKJtu.oIcdH5a	warren.calderon
598	Brennan Sanders	603	4	f	employee	$2b$10$fdvy64MxYJN5ZxDh60T53e2COIvQNUTvaLQg4ggkce7FA.9pulZE6	brennan.sanders
600	Judson Gentry	603	4	f	employee	$2b$10$xxZbdTfQ6whN/S6hMg74Te4MjcThNCZ2W/x2Ik85QceOZ6cjgiSgy	judson.gentry
602	Rhys Bentley	603	4	f	employee	$2b$10$AZ7ztcWUc.tnS9P0D7gfM.UXlgDDIrU8zcJ.U32yrzhV/sb3A8eOy	rhys.bentley
604	Charlie McBride	610	4	f	employee	$2b$10$KvOiB0EGC5OUsY8yy6jI5uPGdaylXipRbrQTtK06/RT/3Ra6pRs2S	charlie.mcbride
606	Harris Long	610	4	f	employee	$2b$10$sK1OWj0S/styk8KVLh39Ye8wb4uAzsGkrcJqJm1.baew6lQ3LV/tS	harris.long
607	Jade Nolan	610	4	f	employee	$2b$10$fVzT4RRH76y0jXZ0nn7YH.5DX6pLf2smSn8/yMOTC7rrzU/XDIg8G	jade.nolan
609	Ariyah Christensen	610	4	f	employee	$2b$10$OJxA9uTKhtwMc7ynx4ppyOgxZpyIJmsQF/q5SJCLmQmnDWUS5gusu	ariyah.christensen
611	Annalise Leon	616	4	f	employee	$2b$10$yzwdZ9lo6WEaUklMZc/wKurO7oMj6T1cJlr3hqeq.mD0UuxxXmHre	annalise.leon
613	Charli Delarosa	616	4	f	employee	$2b$10$Tw4k5SPPPYqCYJDv8e7QE.ffg94NXmu5fXFWbRIbE/gmWFwpz1yHq	charli.delarosa
615	Piper Harvey	616	4	f	employee	$2b$10$yf/rwO74.REjC10oEuack.xleChp0zdXKaaPje01Puy3R9BhCYhKK	piper.harvey
616	Cayden Bravo	712	4	f	manager	$2b$10$hByH0IFvOJ/hBoVBv7IvSOcGFf7EblgPkgfW/rMp4eXJ8VtdJ33GW	cayden.bravo
618	Skyler Kelley	623	4	f	employee	$2b$10$dYs2I06/Ui4vqWYSxCdRFuNaK/o4MTCHrU6OxvalZuvLp7yilJRcu	skyler.kelley
620	Lucca Hamilton	623	4	f	employee	$2b$10$6N.tCUhObPaSL8F2416/Y.xl8o2MPKGR1.57LWzeSAoiIS3Kk96q2	lucca.hamilton
622	Jones Calderon	623	4	f	employee	$2b$10$1e1.i13xunEFmjDCf2zcZuzAVpe8VsBb6.hP5p30MNOQanMOfQQhS	jones.calderon
623	Serena Owen	712	4	f	manager	$2b$10$GqYHEnBd.aP7EaAPBSnuEugETNjzWbkXaF96mIEPRXxh.lrBgPQTS	serena.owen
625	Reagan Evans	630	4	f	employee	$2b$10$dIGZqz6RZx0HSvFFWeWxP.1xkI7.vV.b7eGiZ.026kizz5xE5tFS.	reagan.evans
627	Mara Ventura	630	4	f	employee	$2b$10$2jHBZrgx55OPL./KDt5O2uPh8R4NKkCY.8i/bTFJ3Kx.qMO.Me8iS	mara.ventura
630	Atreus Brady	712	4	f	manager	$2b$10$Mp63pGnWKNVxdEROT.70FuXPoTFs2xSisCnhRWGOaq5Mg0LIJ5MBy	atreus.brady
632	Jaxon Roach	641	4	f	employee	$2b$10$Ughbr1wKsazS8I2eqtCTFe/0CIbG8VpVuvKO5H67GwNRLpm6mchH6	jaxon.roach
634	Leland Andrade	641	4	f	employee	$2b$10$AMXtotXyP3kHYUjqJZ6VnuzSftkKte4y013.qY6yWpC3xgY5M0bMa	leland.andrade
635	Emmy Farley	641	4	f	employee	$2b$10$DOZ7fn/aihQ6lgRhXN3u/OPAMkbVTg6jx7TTdSQ23ugvf6L1nkD8S	emmy.farley
637	Vivian Duffy	641	4	f	employee	$2b$10$BNGllPDPyZVO0c4Ewvpx1e8KKeG3r3KAhwXk1xiYCWHyXfzH2hA4u	vivian.duffy
639	Chana Bauer	641	4	f	employee	$2b$10$.16LWGtVcgJ1Niulj8sZEeccniVF91FGSCqrislt4BkhouwZLG5.m	chana.bauer
641	Yaretzi Phillips	712	4	f	manager	$2b$10$zfm5uZyuWV0dfvQ5utrBXuXcd1Ez58CnxKMTMOl1wYziaoaaq5SEa	yaretzi.phillips
643	Alondra Ward	650	4	f	employee	$2b$10$Q4mq7XELoxZQS3MteFJmFucWS1DZ1/Ai3tk6kaC78ve69IgDC.caq	alondra.ward
644	Jameson Phelps	650	4	f	employee	$2b$10$U7izKhgm6YHPwInPCaJ6BerbTUOc3cstrCtZLRMeEKOkmAlZkxPZe	jameson.phelps
646	Blaine Ponce	650	4	f	employee	$2b$10$D5m292sNqoDNY4q8jAQPEeiea3Dl9Nu1eYv25FH2WltEog8pspopO	blaine.ponce
648	Waylon McCullough	650	4	f	employee	$2b$10$9zJVtbHrLES34frE6AZT0uguxUixD16bh9cuUMjA/c4grcyUm/VOi	waylon.mccullough
650	Conner Crosby	712	4	f	manager	$2b$10$gQ3xy0kcAHuTg/it9Ztxp.eH4ESKzy4NkcIzdGmPdWQkaBg3GqbUG	conner.crosby
652	Jakari Anderson	655	4	f	employee	$2b$10$/s7BJy7uSYPHc/nTdkOLpOhIQzSp1RWZG0EjkRKSoXCg.2qpJcDEq	jakari.anderson
654	Willie Barker	655	4	f	employee	$2b$10$5NKuKEFGSJA5tEJspUyPeOiZInhmG3Uy9CfP67w3g7zjqGA3oAMom	willie.barker
656	Jacob Brennan	674	4	f	employee	$2b$10$7XtEDdHp48nJ/rUaI0F9meyi/9UXQDGrP07nxJwXfQtHD8xsLLrDS	jacob.brennan
657	Elodie Valdez	674	4	f	employee	$2b$10$j3Aesg5sN/oHV8D7CjUZ.uYMPC3mZx1qtjkd0A63rXkzyE2K67EAW	elodie.valdez
659	Emma Xiong	674	4	f	employee	$2b$10$V0lHAX.6SJjQXNRbcqHmIulZYTG5ZJbAn.IcZDIL3Kyv7Ph59RaIi	emma.xiong
661	Luella Freeman	674	4	f	employee	$2b$10$cu0YZRKU8wvU/6P0Lr8hzuHwhN6RnNJCj6PRws28Fv2JQ9d7sYvHi	luella.freeman
663	Valerie Rasmussen	674	4	f	employee	$2b$10$UJVFY5gQHeYOuOCvhpk3/uIFTY5YT3f8IKI7K.iDpQGQH8ohpzytW	valerie.rasmussen
665	Xiomara Raymond	674	4	f	employee	$2b$10$IbeK6yCPcrc3XYXbfygS5uV9TyLX.7CSSYeisrfjeg/26af5LH0Zq	xiomara.raymond
667	Jaylah Cantu	674	4	f	employee	$2b$10$7rSSPX/.C.cnEuJKcVX.JuX.xUTmzTLgw4MN.nnB0BTt5eq7beUla	jaylah.cantu
668	Anakin Padilla	674	4	f	employee	$2b$10$0Nlm3XnJ5Jmw1GEen9veY.SjQKhFXRzvVPGWjORB8RmNMMcUsrs/S	anakin.padilla
670	Kelvin Sharp	674	4	f	employee	$2b$10$aw8o/HjVUvqr2iX/j.xxkOBVeH9Z3KGu6BEPT24QU/QjdmdVcLTge	kelvin.sharp
672	Malik Hogan	674	4	f	employee	$2b$10$yXNNOohw3qxVISRgf.5b/utTketJOaHhTLxv6q/39D0hcxSoPEZ3G	malik.hogan
674	Gregory Maddox	712	4	f	manager	$2b$10$RFaJ5bzQb2.fzhLSVWNtV.3VhabZjWzqW.c4.Fa5l7oj250LNb5fS	gregory.maddox
676	Griffin Melton	683	4	f	employee	$2b$10$PHLSBdHRpjaufLb3ethk1uorETwrZlEe7WtVBYioy3Izt0vVtq2gi	griffin.melton
678	Elian Glover	683	4	f	employee	$2b$10$MNwSGPfkTRwXUsDbfXYGXeQrc2CG.12IoyGvVXs0BBRkx..UYgjo.	elian.glover
679	Alessia Hood	683	4	f	employee	$2b$10$EAMHzus.BTPXeB3uCmal.OI117YPorkOBnohJvmDaWYsq0gYIFbVS	alessia.hood
681	Amiyah Cantrell	683	4	f	employee	$2b$10$Peu9KUbm3coUxOAQx5eNV.igZt3Bt7KOpzFFbSwmd6XE99qOsTXbW	amiyah.cantrell
683	Millie Lozano	712	4	f	manager	$2b$10$HYFcKFR1MrD49PSbrj7EzefVbWRgCEVLyKY6ept7ST4lPsxbXcPva	millie.lozano
684	Boone Yu	686	4	f	employee	$2b$10$Ld.5Ajf8Xsy79v44hwOklOsiaF8vXEZIi2R45sexPuZgyO..4Obd6	boone.yu
686	Chandler Jackson	712	4	f	manager	$2b$10$WaNESu1BJTi3drjfD4LHUO.fkU9ARytEDE.ZwSBGN9fc6UKPldysK	chandler.jackson
688	Weston Payne	694	4	f	employee	$2b$10$uks/zLVXAIsGlEEPtD9t1udh1rzo9yYcy2W1zgIYUzLE3QFKi9q.6	weston.payne
690	Colin Mosley	694	4	f	employee	$2b$10$dhNdO4MRaiMCYKlp42fd4.7ZOSqSCuV0fac7.3gORz4gapUJdwGFC	colin.mosley
692	Cohen Sierra	694	4	f	employee	$2b$10$qe1xAo/Z3QFJHa9MrcdCCef4BQFG7iPHsrWeSn/rU6U0WWpYw9IV2	cohen.sierra
694	Kye Giles	712	4	f	manager	$2b$10$E3/G8QZVLamdM6f142IeSu2VbivFEFawupmuF5.96qG.mG0y19myq	kye.giles
695	Bailee Conner	712	4	f	employee	$2b$10$MupUPoGSs.Q5w6XJsHLGcOeT5fYkHDq322mqgrp6tlT8X1K6jylEK	bailee.conner
697	Raven Vu	712	4	f	employee	$2b$10$TRG4OnRjN9lgoigy4UujBOWd9dOtOF38619yrMJkcvNx2I8Gl4cRa	raven.vu
699	Lilian Boone	712	4	f	employee	$2b$10$KmuBrFswA/YggOhJGwscg.F2Eg.Fjbg5OU3sUykPIioAmScwAIqfe	lilian.boone
700	Mauricio Wilkinson	712	4	f	employee	$2b$10$a.n4yrpJ5QFF9alH2493rON0nFtEtdrCKaku.WO/x.9HhDHMJVNtS	mauricio.wilkinson
702	Adonis Pope	712	4	f	employee	$2b$10$SlFn525dM.5/ZMh5edej1eA2zEIRsa.Ia77KLRG53b.LxFk3pCN2i	adonis.pope
704	Damon Keith	712	4	f	employee	$2b$10$8zA01QMnG0tLnXN/kri7FOh31dTCBbGZWwYWoIBfSW5PJxJzxFhGi	damon.keith
706	Nicolas Aguirre	712	4	f	employee	$2b$10$WKacxbBWrkiyDaaS20FsuOlWDT/oo58RxQuEm4GFQkpdKXb8Yssoq	nicolas.aguirre
708	Isaac Kaur	712	4	f	employee	$2b$10$wottT0Fs1.LObiOAUKbTh.x2HyugyNSRaviolOMPw0maROKu2Lgs.	isaac.kaur
710	Rory Raymond	712	4	f	employee	$2b$10$5..5A.V2qaxcsm.rUQOOB.2nWuREgTxEuIPRV2cx5eVc3dD7dImX2	rory.raymond
711	Hadlee Love	712	4	f	employee	$2b$10$Asz4/EZd.LyA3RRfH6BlL.nBHhOnf.HRR5PbxxxABglIbu1QAU1CO	hadlee.love
713	Tatum Boyle	719	5	f	employee	$2b$10$rGIf5REmPK2o/UjEdO6UuefPiznoxIwJDnWdFETKtIhhJTVIJi1Ei	tatum.boyle
715	Romina Velasquez	719	5	f	employee	$2b$10$sTwhBJuEDKtdaJwbszhPpeBTt/fphgowCbCT.pcQqjpOHV.bhhqVu	romina.velasquez
717	Nancy Holland	719	5	f	employee	$2b$10$klELwNBWtc.wn3nyxTREq.BHwDwvqI3EcHBQqUYl7Lzy9wy4Egoey	nancy.holland
719	Sadie Ward	934	5	f	manager	$2b$10$iKrCK0TEHXI1Fzya8vDZJ.8o3hkTfw/eHWAjdFbLvhrTG2s5Pa3OK	sadie.ward
721	Whitney Hester	726	5	f	employee	$2b$10$w1spjAL5umHE0xk40klwPu5IKPKCFOp64/hpBaevFTgiRkzV2/Jha	whitney.hester
722	Rene Sullivan	726	5	f	employee	$2b$10$1zU2a/BWtpH067JR.EVg3.nmDw/RquGRS7rO6hpoCXxSjrbOlLdli	rene.sullivan
724	Paxton Santiago	726	5	f	employee	$2b$10$meS0vU1uXh294h9XlrG/1eVKiUf.7aOOmySv7mRuJLqxZlOwRTLeS	paxton.santiago
824	Arjun Quintero	831	5	f	employee	$2b$10$5LMNoEcmBIPQo1Ir4Ou3DOZSnHQ/YW38o/8iOymnY7luiuxwV2Pzu	arjun.quintero
40	Leandro Branch	110	1	f	manager	$2b$10$bgn3VsUZ1gmDkuCU0ySvROF3jwuk3SR2rgIeY5OQ7ipkXMamo0sXy	leandro.branch
43	Margaret Dunlap	48	1	f	employee	$2b$10$kWLQ/sC4CR73E7qT3D33Y.f98yGqAuq/IiRwfotyGW1Tw7WuHDCRm	margaret.dunlap
45	Melissa Buckley	48	1	f	employee	$2b$10$SR8p6.DzUvaSHMsLGZcRcOFPfxoBEj1IH1LAitpxUX6u3ngIdi9vy	melissa.buckley
47	Harleigh Gould	48	1	f	employee	$2b$10$SfZ3fZvZJ3OtCXsr75NBje2IEDFUt3ULyZsaC8nosG37URIvpByoq	harleigh.gould
49	Lexie Barron	53	1	f	employee	$2b$10$177DdXSoxNxkxOsCsgRMOuS4.MkpdmWj0LywXYC6/mvRyhprDwWS.	lexie.barron
51	Hannah Livingston	53	1	f	employee	$2b$10$ptEvOMMUQswjxNHOS0hRpe.YFe5qU4nDoJrqCA6zXnd8BAF/SoXq6	hannah.livingston
54	Joe Arnold	72	1	f	employee	$2b$10$nCUyC3npP7pGndfoEo/0aOqDE/ehZ8j6rt44cKDAqdYXaP28jLs8q	joe.arnold
56	Frederick James	72	1	f	employee	$2b$10$xWprsAzJH29tB0rAp59dWeSkZ8SXXHKwB3EhHNL2vhMAf6Oq/hoeK	frederick.james
58	Archer Green	72	1	f	employee	$2b$10$LYS19kowEEhJSCVO/wC7aukOKZteXdTW9nmlckE4x8h5dJ3ChcMdW	archer.green
60	Peter Armstrong	72	1	f	employee	$2b$10$NVIGk9vCJ0pMHf9J3t3CdeNQAWfXKxUbsJ0RxbxE9Haz22fcynCVy	peter.armstrong
63	Isla Rodgers	72	1	f	employee	$2b$10$O7V9VPpopAm3mr9tas1T6ukz/KqNnejAzSC.B1Hia.b5yUIRoTH7i	isla.rodgers
65	Vera Keith	72	1	f	employee	$2b$10$YmdSJeGjvshBsgw09I0oEeUaHlN3ouIma8JAEqYOvQm6K.gK0k2de	vera.keith
67	Selah Payne	72	1	f	employee	$2b$10$4/Rv/jprCVn2i2w00fMwluD0lUuhvVSewxbgtseS1VTvMNzz60JvS	selah.payne
69	Maeve Melendez	72	1	f	employee	$2b$10$3Q1FEzjJTawfA0ytLv.MH.ijj8eQEnguXPAMVJdCutaBKbuNSpOhm	maeve.melendez
71	Alaya Pope	72	1	f	employee	$2b$10$HlxuGElj/81W4b0xm897D.TzOUdTima7DDtWfYhSoDnYqTRHeMPlm	alaya.pope
72	Gunnar Maddox	110	1	f	manager	$2b$10$BSeaKcqtsAboB8lobrjKKeZMBC3S5uOfF2eOEgYU5LwTMvi9EwgRy	gunnar.maddox
4	Beckham Hubbard	8	1	f	employee	$2b$10$.dfhIWviH1auMfpD3Uvx2uPJQ/sQDRWRJUU8MwqTqtx6yWIuAiMJa	beckham.hubbard
6	Jace Delgado	8	1	f	employee	$2b$10$7SPh2ULF3Zjn98q1ESaC4uYm31d81osnoZxD8grrMmNYZxRD3o8AC	jace.delgado
8	Brantley Whitney	40	1	f	manager	$2b$10$Ui7HnKZTdry8xf4EA/YktesvlrGfl5sslogdwLeLccKGBcyf3f8G.	brantley.whitney
9	Madalynn Dunn	14	1	f	employee	$2b$10$xpZZ4VXup1euQJ5inlyuweV9T1BKaAnSw2Vr.lhxQP8dhm7a8z8UG	madalynn.dunn
11	Juliette Mueller	14	1	f	employee	$2b$10$F9IcI67NwUcWI3b7B20yY.EP8sori8z17zNpQvLR9f05rTgiSJQ1W	juliette.mueller
13	Miley Cline	14	1	f	employee	$2b$10$/NG4tM2PixkVTEva3w2mpuxedafTS4O/4fWtwESScw8m6UJj1US/i	miley.cline
15	Everly Barton	21	1	f	employee	$2b$10$PBQ89fVkdEoQQU0LRZQb/uBPY53kUoKgbb2NkF6AQitvpCnWV.Fga	everly.barton
17	Ashley McCullough	21	1	f	employee	$2b$10$PfG90CMCnc1LsaTsgxPcKO/P9zk1BlRVuduCr.cKZ0DUGhL.X0QWq	ashley.mccullough
18	Briar Bruce	21	1	f	employee	$2b$10$C8Py1nWmP.ERhN.xuvnyWOkyaO0Z6V7.ksWj353zN49ysBp1FZEQ6	briar.bruce
20	Jair Huynh	21	1	f	employee	$2b$10$BNih1cJ.JlOAK//b2yjBbOFXZyiKaNed4pONQLqL8BDhnxTNUb5ta	jair.huynh
22	Ira Whitehead	28	1	f	employee	$2b$10$c/kWKFhDfOx6Sd1ZdYY07upo.Dd0PJZ.ffTfIIwTxJuEu0f6C98UK	ira.whitehead
24	Zyair Nichols	28	1	f	employee	$2b$10$BeL4dPFTLO80oP2/E6Ixh.skCD8VNXpLLxYvEZF8ta9Bse0wMazzW	zyair.nichols
26	Everest Lewis	28	1	f	employee	$2b$10$rgR.xHPpMCH2QbedWF8q6eU8fASptjawxsTYO4Dp1Tc3BWBvQu7X.	everest.lewis
28	Brayden Andrews	40	1	f	manager	$2b$10$Gz5qabZqA5pk.9Qr3tRecObrura8Yk5xFSj7hRmKdO1cSGGYd.feq	brayden.andrews
30	Emmanuel Bernal	39	1	f	employee	$2b$10$OjgOeepHBveOY7sf/s5SDOuuedKb6Lh4VUdQt1bOIBR28nCAmIM4W	emmanuel.bernal
32	Leandro Sandoval	39	1	f	employee	$2b$10$wfTUjEDnjK6/.x1a9v9snup80JODeeG.TtgtNhb/CTwNg0FkDTBBq	leandro.sandoval
33	Elsie Pittman	39	1	f	employee	$2b$10$pKryNFC2zoy45c60qHaO6.oykO2gnRqaMVAqNma6x9DeQGiN6ARU6	elsie.pittman
35	Kelly Spencer	39	1	f	employee	$2b$10$gkiXPuDUdPKBKvwJhZT2bONSi6hlZrnvzmxzsnIrDljPE//T9ULxe	kelly.spencer
37	Violeta Peralta	39	1	f	employee	$2b$10$MkkdBoJUQxq9IAKYZJtnouCEUICzD/2ABWkPRXb3nfpQNgedLp5aO	violeta.peralta
74	Caleb Melton	81	1	f	employee	$2b$10$/TNZnEveEw.UL.gqA058oeylGvOsvb5pffZT/Vsx068YuoQAeOz2W	caleb.melton
76	Fisher Cisneros	81	1	f	employee	$2b$10$zZ3DY1b5gY1e5Ken/ErLw.0bCj8NhOYlgJ2QTQ0A3QctSWtarzs/O	fisher.cisneros
79	Loretta Frost	81	1	f	employee	$2b$10$zXTI2zZka./.4XSE5GXrEeGjwzWzF4779RfYAJR94eDCzOLhcjiem	loretta.frost
81	Alaya Fitzgerald	110	1	f	manager	$2b$10$Ijqd.u/JEnf2dRuyuFo.a.NWLlgiKsww7Q4q8TGbF7clmqvLPg4Ui	alaya.fitzgerald
83	River Walters	84	1	f	employee	$2b$10$gpXleNBRd2siJX0193hriOVWnAvxc./Qz02vj23Yz8IE6Z8SXIXsG	river.walters
85	Grace Dejesus	92	1	f	employee	$2b$10$4Ih/nCu6inw2plmT6JLkN.lCH3scX6ODRfVly7MM1gCM6zP2vWxWW	grace.dejesus
88	Ayan Adkins	92	1	f	employee	$2b$10$tv5s/VZJq7uK0hIfn6pQae0AePumxFrrvPAEkdkjiy.U9kqupXE6S	ayan.adkins
90	Avi Alfaro	92	1	f	employee	$2b$10$Lx3cIxDtHz3bOS7codoOj..U1EYek9nE7lTgKimGLAghASQf76NdC	avi.alfaro
92	Kaiser Mathis	110	1	f	manager	$2b$10$4hp.5VGrMBqWtz/1A3/6j.WIuC1jg6OetxY/Ub0.oOcbRysRvDmYW	kaiser.mathis
94	Bruce Knox	110	1	f	employee	$2b$10$uW8OIDlLzTUQtWAJ2kW0b.K9gMt5o4fT5seVFsW8nKciIeqVmDViS	bruce.knox
96	Damien Barry	110	1	f	employee	$2b$10$/xnO69QaGAzQ.ESZRBFn4ulJSMxB.Ovhtqkz.NuFntYT.ffxrKMxO	damien.barry
100	Niko Mora	110	1	f	employee	$2b$10$miDOG1VSLlvt4BomI.WWJejstLKRvzQVj6TPmDVzXTydWcTTAEIhi	niko.mora
103	Ashlyn Nunez	110	1	f	employee	$2b$10$xWG3CfPa7SDA9Mh67rTKlOFd/YtC7.uxkoWF.xhdJzMF6Z/s7iVZ2	ashlyn.nunez
105	Marisol Calhoun	110	1	f	employee	$2b$10$5FIURw8wDqybI1eii1ZsUepV/8eX0v65tkv99MbNgtwwBQz5ciIM.	marisol.calhoun
107	Mckenna Willis	110	1	f	employee	$2b$10$89m1V6fVfxENyt91kK2xGuH.u7YdlZDhQzJ5onNCa1CtxURgio9PW	mckenna.willis
109	Miriam Sexton	110	1	f	employee	$2b$10$YRIUs5V5qoYzefJBkrN9pu1/sMwIM0cj09avCaciHcFfQWceOAzn.	miriam.sexton
2	Clay Li	8	1	f	employee	$2b$10$qCUhOHRcQK7.z3PriGIBeuW9y2fkgj.Truc.ucNBzmtHUgl87eCt2	clay.li
113	Hadley Moon	117	2	f	employee	$2b$10$RHdisy3SB3PSxbUEX2iFN.zSg3Kc3lXlO6ehVY253fZSdYHSu1SHq	hadley.moon
115	Adelynn Rollins	117	2	f	employee	$2b$10$iZWoz300zcNwQrmv2pZ9n.xW0AddgXBP9dLpuu4C7lrCWH3msJYA.	adelynn.rollins
118	Colter Owens	123	2	f	employee	$2b$10$7UiPiMEfUEw9CpSiws/kU.YP0fqS0sir/CxbQC7WMque/byqitRKG	colter.owens
122	Jason Townsend	123	2	f	employee	$2b$10$4FbHtg7Sd5nv1l7dMcwdyexFcVw60yOKenmQ6y9gYlOR10pHbnG5S	jason.townsend
124	Callahan McIntyre	130	2	f	employee	$2b$10$vDhe51zt3gH8Y2xVqbzJU.AKDbDipviYAi4F9OEZwzS3SmsAeS1Oa	callahan.mcintyre
127	Halle Pham	130	2	f	employee	$2b$10$FhELcnMl8wzH4Ef2f25jjeaOy9EclBF.3KVoOjKqsil.cnCaVsAcC	halle.pham
129	Marley Reid	130	2	f	employee	$2b$10$OE0IMd0t.OyfRsDxzw4z9e18RXlvWEuATWBcxa7o9Frhg8JGRffMS	marley.reid
131	Bexley Bullock	137	2	f	employee	$2b$10$fNYyh7vUYgq8.Ai111JgH.qs5M/y2JGTeGEHhkeYJA43zS8MHKsxi	bexley.bullock
133	Lila Valenzuela	137	2	f	employee	$2b$10$jd7w.ZHvMPACztpwrz7GC.7dH.G6mGhZBV6Y7fpiRmMiBs5YHfJB2	lila.valenzuela
135	Adalynn Long	137	2	f	employee	$2b$10$egmHyYLW.Yb..0LatD3GhO4qS2cfbygq/oQvZTwGZn2fWBknPyioy	adalynn.long
137	Jane Preston	190	2	f	manager	$2b$10$Oukhi9fPnJuJhUeDww3VfedHwQbO7PMNZnL2Hmr0db.SnRyGmgCBi	jane.preston
138	Vincenzo Cobb	148	2	f	employee	$2b$10$MO.ZHeoyUkd1wN/lKf3fCu61q3Z6G/aIkdPVFUcwzEKV6dPq1qZBy	vincenzo.cobb
140	Ford Chavez	148	2	f	employee	$2b$10$hQLWCzqpNEX.Ek9ng/sqguWcnFfLVnNjdk4Pyf/4XbJCQs5tVNS7S	ford.chavez
142	Rodney Gaines	148	2	f	employee	$2b$10$YY5IgXqZ1fjk24zE82mmyuWHeVtTtbOdfyftLLQ5qlNgpvkAO6.sa	rodney.gaines
145	Colette Vo	148	2	f	employee	$2b$10$sQEV7kduJfatQ7SC4JsEw.cXX8XiJTesRc.RqndgWnonuJFS/Jt92	colette.vo
147	Lana Conrad	148	2	f	employee	$2b$10$8PTFWvxHhV00iNZIuSWTKeeqgSdN0ANhOXKdWh7b21bvXsL/ZBxY6	lana.conrad
149	Adele Nguyen	157	2	f	employee	$2b$10$fShlnbKnaRxu60DWnZC.ROeQqdj4nLWaemSSd/Bs8iakEUfHMwvQi	adele.nguyen
151	Francesca Hartman	157	2	f	employee	$2b$10$xZPJI0vSyiUpmJnN7XV4bufDrSouX4/jTK4QSV05dTSe/z9TbxH2i	francesca.hartman
153	Lennon Blackwell	157	2	f	employee	$2b$10$tqO7gkqkP7T2YxIxqXoIDurjIXqFkh4.C4KylytZYVw63pRWCBZLK	lennon.blackwell
156	Case Lawson	157	2	f	employee	$2b$10$UUpxq89bVbui3K7fAcygbOZc4D71xQnFBrfUnOhUGrgX7YM9.4G.O	case.lawson
158	Beckham O’brien	162	2	f	employee	$2b$10$17pvo.L7.MFyVRCu1/QYfO7o6oMH726kVbPIkoXS4msY9yy/XN5Ly	beckham.o’brien
160	Gustavo Harmon	162	2	f	employee	$2b$10$6UXPY2Bjk5yfKPmgcv0jF.lqpF/Vuuntct0ZjeoXWlQ3HmkHt1ohC	gustavo.harmon
163	Calliope Hill	181	2	f	employee	$2b$10$pcMjy24ReiNh4wr77naasOVHVF4hsCblYYcWPKnX4gkNhGrFSUTEa	calliope.hill
165	Paislee Day	181	2	f	employee	$2b$10$lG/hXrrxMxbS1Jd7Z8VAOOUkF43a6B4EdxIge20cfseC7hZvYGpp.	paislee.day
167	Esther Frazier	181	2	f	employee	$2b$10$NlZYfQ4rcDcyMH.STFfQwe6fjqrHbTk/7e6CgyldLzbUI27Zoq48.	esther.frazier
169	Mallory Proctor	181	2	f	employee	$2b$10$TmQfrX2DErlWqd.K7rc3he2hWnrXKCgdP04MPBlie6KMjPLzYppDy	mallory.proctor
171	Leilani Francis	181	2	f	employee	$2b$10$x2pIPeCDOi2fIXxF3cmu2OAn7vBssqIlK4n0lgA1gX9o3uVYTLxL.	leilani.francis
173	Miley Fuentes	181	2	f	employee	$2b$10$PW.E4xZzE/ux1iXMZlXz4.OGomeRmZIHxo17T399ry.EI6gfjD5tm	miley.fuentes
175	Freya French	181	2	f	employee	$2b$10$QuaUh1VzWQMUNrl/0TmzxOEUlsM5fT6orVQP/lrpkfV2BaWSufBPS	freya.french
178	Stanley Mayer	181	2	f	employee	$2b$10$EAOoEj5cTFjbUtlRdR/uMO8CRiiOTzg58IVXZvBHinks7nhEgttPS	stanley.mayer
180	Connor Carlson	181	2	f	employee	$2b$10$LpBkaiCUrEzo7zMjSoQbNe8NNpxGz8vycykxh/6Ux/lFnVh934Fnm	connor.carlson
182	Dakota Marshall	190	2	f	employee	$2b$10$sZzZom4bI50tC7CBrZZ9dOkiJrMuhnJYflGEVvmGl5kbG9chhJri2	dakota.marshall
184	River Kelley	190	2	f	employee	$2b$10$B81Jq5lHex5Tr1dA0Eql/OAhoro0J2dWWEN3YyHmOSw1vQdOX7APC	river.kelley
187	Isabella Knight	190	2	f	employee	$2b$10$/biCUOo7m2SSgJFFwuyn7.rXm9GE0.Yuszd0VCWsqKECP0pbj8alG	isabella.knight
189	Zahra Patton	190	2	f	employee	$2b$10$BGcxmLIZ618S03sQ/y7Emude6gN9ILMgKvdnoS.pILONjPMMBDy2C	zahra.patton
191	Eva Beasley	193	3	f	employee	$2b$10$XWts70XcfEuZ/JDxkC0BhOCXFo2RNkQDl4yrCW4Rnl995tJiAT6GC	eva.beasley
193	Alanna Hancock	391	3	f	manager	$2b$10$ctlThRIQktSLyhYZY53OKulRDwpyJk8u0cMfA.eXBbqLRz8D4rcSK	alanna.hancock
195	Adeline Morrison	201	3	f	employee	$2b$10$cw5yvGdisOLrszzvrKdqC.tJ29ssi1ONdCoZwiieg728HbwAxKiPu	adeline.morrison
198	Maison Carr	201	3	f	employee	$2b$10$TvEV2V9WNbkFItJgFF5Nku95nH4vG50INnzcPOE1eLxQ2VUXqbQP6	maison.carr
202	Dakota Finley	219	3	f	employee	$2b$10$Q7XVFRXfsCIdE9oCYBpJDOLtStI.OtutWIkCbW0FuLwhXxCO51ZlS	dakota.finley
204	Calvin Leblanc	219	3	f	employee	$2b$10$GMgAaU6PhRnGd7Jpzp1P5.d.HeuQaVuhUXlpSR9bqv2DkuI3qTS4C	calvin.leblanc
207	Averi Moon	219	3	f	employee	$2b$10$iIAhHLDzFSFYcHPpRteQMOrvAewYlZin9xFHD/PPzWl0rG8oVMuhC	averi.moon
209	Meredith Becker	219	3	f	employee	$2b$10$PckOy1tJO963ez9vq/T8lepMaSP4wTQGEHuAkm6X9ze8zrtPmE9b2	meredith.becker
211	Mckenna Poole	219	3	f	employee	$2b$10$IPIAV6dQdvlBoBNugfQSJOASQTVK9GMqprs211UWitQ91nGgIOAfG	mckenna.poole
213	Destiny Compton	219	3	f	employee	$2b$10$MLHM.hFHh53niL1p4rI9H.5x4yJ1faBtpaxh3oXreda2jtmAVM2tO	destiny.compton
215	Julissa Mata	220	3	f	employee	$2b$10$xI7YQ065ObHwgsRKN6PxMuWkjn9OvSF1vL9pbVz/rKX9bXz4x4cvq	julissa.mata
217	Paisleigh Aguilar	220	3	f	employee	$2b$10$RjRGvE8J9K0b6xncoUmgUe/4/u09IKKQpp9PAwaeGiikmorfBvqNO	paisleigh.aguilar
220	Melvin Russell	391	3	f	manager	$2b$10$M1m7Gsiw6hgZMNcSUeIfwu8bfW83qmZIwZy2wtPQSOL9a/SNKtp42	melvin.russell
222	Valentin Mathews	226	3	f	employee	$2b$10$ORdkmMWSmCFXcS4Rlhp3SO5zlHZKlAvd3Ik.Z8WX9OrHI94zmABHa	valentin.mathews
225	Helena Bauer	226	3	f	employee	$2b$10$Yy1kMhmJ7Cq5EKgWgjXco.bSnAxYNImTBZaksfqYjufXCB4RJFm2e	helena.bauer
227	Eva Andersen	233	3	f	employee	$2b$10$srx4rkh708ufJ8zcnAtSh.uluCmubejE5m9mXz8kKgCwGdoIJ8mAe	eva.andersen
229	Paloma Herrera	233	3	f	employee	$2b$10$HkRAH8hFtQNvgKSWS0PFa.VQYHz.TLW9fR3wDxNafbfVf8Ej5Uxy2	paloma.herrera
231	Kaylie O’Connor	233	3	f	employee	$2b$10$jWD0Y9pecpJpOZJHXrGXVu.7OdQqhI3kL/xmx4tIWjNgtCznh8Q3m	kaylie.o’connor
235	Elliott Palacios	240	3	f	employee	$2b$10$ZfRmm3QW1BZ1MQGExFmLVeGg.edcTr4A6AdFqrdv9VOLrxYAzwGCG	elliott.palacios
236	Thaddeus Sullivan	240	3	f	employee	$2b$10$4yTG/asrkS21DFRstVo4POHl8sGmtR9275YEZVxAZtqotJyPA1s.S	thaddeus.sullivan
239	Hadley Moran	240	3	f	employee	$2b$10$pWKP6NQJZw2hoibgL7FA6Orcl5RJvkMBB04/oQ5Y4oJzTCB0vFwsu	hadley.moran
241	Nia Wolfe	251	3	f	employee	$2b$10$DgbZeec6Qh5VkXZ1luLrYeOtBvt149/GD05D.XXLuf1iX9Stfz9fu	nia.wolfe
243	Sariah Day	251	3	f	employee	$2b$10$P3kItbM5qae062fxf1xwX.SoMOo6Q1VLUTZITRultBgPqoKQMV0B2	sariah.day
245	Annie Delarosa	251	3	f	employee	$2b$10$3zJzxSJJ/R5PDOBNOX8W.O4m06QAtmksOCRDAQWl/l9b158axTjEq	annie.delarosa
247	Veronica O’Connell	251	3	f	employee	$2b$10$rcJTpO.J/h9EiXQbEWjMFuJwsNda/eub00ykj0tJNr7Tokz1o4TkO	veronica.o’connell
250	Kyler Kerr	251	3	f	employee	$2b$10$FSizQAw6Q83B2UEX3MBm9uDIJRpfCiYYTLiox84rg3AwQuQXnKgHK	kyler.kerr
252	Jamir Meadows	260	3	f	employee	$2b$10$ddlUUJ.278PS9v4v5dAXUOFys3TD71j.GvtNX2b/qeA3LCVwP9ULO	jamir.meadows
254	Westley Trejo	260	3	f	employee	$2b$10$qM2E6aAjvax3dvtRplWZv.Yue.PW/Babz.YKr6e215fmiwgA.HbM2	westley.trejo
258	Cohen Patel	260	3	f	employee	$2b$10$6hPeK35eXCM/XccC7hQOsOwUGTfErSzSQ0paMioOAyNxmyPuoMT9S	cohen.patel
260	Kelvin Stevenson	391	3	f	manager	$2b$10$5Sp2bHPjNvo/6JqhJ3fMv.8xKa90moZeia2OiidzlvZ7tLIrTafb.	kelvin.stevenson
263	Loretta Collins	265	3	f	employee	$2b$10$w5/xuDhQchvTQk1bIdRf/u8M.tb/yefYdNqxUlYubYTDNjsj0MFN2	loretta.collins
265	Mary Valenzuela	391	3	f	manager	$2b$10$wcnLmi2JPFOd//NTHlN4LuIc8YtpOhAA3M02qQ01EnKL3L6eAaV.m	mary.valenzuela
267	Itzel Callahan	284	3	f	employee	$2b$10$otPzEsxWXtXc.VE7aZQNsOyaIZxSNJjYxfB9Io19H6tIA62nzZLhu	itzel.callahan
269	Remy Leach	284	3	f	employee	$2b$10$VyBogRO2e25BPcsyVI1ZauBRloMghAiPN1BGu1Vblt/dNXq3HRaZa	remy.leach
271	Rose Andrade	284	3	f	employee	$2b$10$igYuZgWG7aTlvnAU.tFyPubIvZHBMoOHkjVoYRPj7d.5rfRISYAr2	rose.andrade
274	Azrael Ingram	284	3	f	employee	$2b$10$UrxG8suByaZznN0P4xRymuft7Ry1httXDy6QA7xsFoM12rcgOJDKK	azrael.ingram
276	Kenji Ferguson	284	3	f	employee	$2b$10$wxusonWTYz4cYlHtG4B0P.gTAJu4rRLuYhbiy/Nq/gq1khhzuLLti	kenji.ferguson
278	Quincy Bowers	284	3	f	employee	$2b$10$mwRENufZPjMi2sLqBw9NAeVR4oZ8JLpQiAOpcThqpU4bvTs/bTQgu	quincy.bowers
280	Brayden Cameron	284	3	f	employee	$2b$10$/CFXqDsCWMxUj3s6WMSE5.trk0mmXZsvxgrqpHlK6l3acGkbPFvkK	brayden.cameron
283	Ava Grimes	284	3	f	employee	$2b$10$XsGCxSeMGzDM/nwX9SzkR.TbaBH1eWrR.BXShoZpjwaHyI.7cH7hS	ava.grimes
285	Landry Hudson	293	3	f	employee	$2b$10$6Amk5hXXv4RmI4vH7RvRpeVUertgJMl.7vrcDtEgZ0jf.lymr2WI6	landry.hudson
287	Kimora Jenkins	293	3	f	employee	$2b$10$o1lPgPJOZAhIu9i9HFL5Be2/SEQw9I682tNZMXOh4MUdorfEzkKNO	kimora.jenkins
289	Elyse Reese	293	3	f	employee	$2b$10$CbsPvlraQF4ZunnjwIVtaey77wJfF4N4wC9UvjOdSjv.QmhTnbW8m	elyse.reese
291	Lilianna Welch	293	3	f	employee	$2b$10$fEXYvsdNB2V6gW8fwrZz/.UtDn/ipSjm7zbe/sgt6zmzBqHAwxdw6	lilianna.welch
294	Kristian Shepherd	296	3	f	employee	$2b$10$PAM.1CR3IrI5Ts0BakieOeJBzxA4O6IU7y2DPJW2Mbb39eRmmVR0G	kristian.shepherd
296	Rowen Estes	391	3	f	manager	$2b$10$nZAPilqNlLXLv7LEPx7A1eK4whCsPpJpU/iYLkFu5GDoHjl3IqH/O	rowen.estes
298	Case Holloway	304	3	f	employee	$2b$10$izk2cpvIXC2hXyEO/IolROD8eAXpe3i259oB3xl7bZbdmeH.t07ri	case.holloway
300	Bishop Ramirez	304	3	f	employee	$2b$10$WhxPtTOCiWN.0L55TrI8a.EBbluLN9W1ucAckKCfHbz45MnP251xG	bishop.ramirez
303	Sunny Gardner	304	3	f	employee	$2b$10$f5dPndFC3S1EAYW4XlFxLeZb0CIjrdBF3x.iB6tRfOXGjwOtVUIEu	sunny.gardner
305	Malaya Garza	322	3	f	employee	$2b$10$pTWXfyi0Nu/lHuUeTRrAKeWXpv.rpoiFLfB92lhdhnmeK38iniqf6	malaya.garza
307	Maia Savage	322	3	f	employee	$2b$10$hqtzhmz0BJTx6RRJWMfwbOuPkhT3PV2FAhdLNGa2HoIBMb014fDqK	maia.savage
309	Makenna Ball	322	3	f	employee	$2b$10$FOERe1NhFs7vN/lFUqZFl.e4RrD4g.N5cWpk7ORQrGpIAqF1SyFua	makenna.ball
311	Abigail Jackson	322	3	f	employee	$2b$10$JKPIWKJ3NDntlI5ZVa53vOEAQRXaNi8Q/TNRzIPCyKoDN16QCRE.2	abigail.jackson
314	Niko Lozano	322	3	f	employee	$2b$10$W5XK0pHDKUarM1BJNeAbwOGpD79kTzjAW.NQeUcZuH4Qc.D75BBZC	niko.lozano
316	Edward Valenzuela	322	3	f	employee	$2b$10$p8gNmUdLm/I6mrHe5vX2sOel6Eygz3NkVepvTQOuMbsq29nHKGCGO	edward.valenzuela
318	Lian Soto	322	3	f	employee	$2b$10$rxFqyOEiBxr2vCbxHs8tDutFFrIG2cOvLsP3m174Y/5CmF4gZ1mYW	lian.soto
320	Arturo Herrera	322	3	f	employee	$2b$10$yuTGqm1RNfASASuPOm620eNXXj07o/IVGsxbfLG8ey5XK/oHzEvWW	arturo.herrera
322	Carl Klein	391	3	f	manager	$2b$10$PVF7OBrlb9l7Yraz8804LeVV.gEX6hm9bNjrs9L2KmU5adgLiDt9G	carl.klein
324	Casen Farrell	327	3	f	employee	$2b$10$.FvEcGG5LttlGj.rboN92e7aZkgR4X.tUIdde1c5DhaMDb2d5wIP2	casen.farrell
327	Lauren Barrett	391	3	f	manager	$2b$10$FEf61b8seW6bKYm59qzW5OnpL4Slujevk9I3ZSiT5q.EikAF3alKe	lauren.barrett
329	Egypt Reese	338	3	f	employee	$2b$10$zlAr0YcfKS5hlsDUaeIH5uRcWq8n7LPTxVkalXT7kktb/cyqouJjy	egypt.reese
331	Carolina Adkins	338	3	f	employee	$2b$10$5yt3suAq9C4kCvWky1JBXODCTIhqad3xjn6g.xU3qIcdjclPQAHXO	carolina.adkins
333	Kelsey Walter	338	3	f	employee	$2b$10$i8MO3LcLJFYoONqmgUDOA.4HUg58ANvgUGQ5AxcnqAdGy.t1XMIJK	kelsey.walter
334	Lochlan Wise	338	3	f	employee	$2b$10$Ytz6.OBJcsOHds3lwgB7IOcInC4CbIdHPcq5IeFsBqDBRPX.sEgqi	lochlan.wise
336	Cal Leach	338	3	f	employee	$2b$10$X6i9tdW8IEPfQY1jAS5f2u5vwdo93vjDFPhKuHcT/ZFIMeeM/sJOG	cal.leach
338	Marley Holmes	391	3	f	manager	$2b$10$UVM12/fzrX0IrBlbaLH7keXArBkHgDLjSDSWuhymreYhoN6Sl8W0K	marley.holmes
342	Muhammad Kirk	347	3	f	employee	$2b$10$YU.ze5vKU3mRd57fcmt3Qu.Qd9G.j3q2BEFcVSn9953sYHtdmqaWq	muhammad.kirk
345	Kaliyah Beck	347	3	f	employee	$2b$10$HFro2O.GwiksZp0cGVVtQeEfODIfEz2.daXya/xoeF5ixnCStDnV6	kaliyah.beck
347	Nancy Bullock	391	3	f	manager	$2b$10$ISvnqj0Ow0PXn8/nk3URbOLYKGhXkHKVaGYDx/Lm6u.gqyU0DrzZu	nancy.bullock
349	Irene Melton	352	3	f	employee	$2b$10$x6jrlW9QnhzxddpL0WV1l.ajZZ3aG5U9WJNe1ZgOkRI4VgnVYUsWC	irene.melton
351	Drew Shepard	352	3	f	employee	$2b$10$5l0zt0M9w742oVySGDtA1.jEEyDHyBTfB3wqc2BjXqwUieghMVFkW	drew.shepard
356	Marco Anderson	371	3	f	employee	$2b$10$4AYwFUz1hSBBdh4QgVKddupiGJqgikLkDKJs.hQYp9DAIpaR3IebS	marco.anderson
358	Heath Anderson	371	3	f	employee	$2b$10$mixc61F.gWnSp1CwcO3ZQeyem4p97OoUcu8j/P0r8yU7qPOOAhPoK	heath.anderson
360	Atreus James	371	3	f	employee	$2b$10$UCFj3KJpg/1pGGUuhW11.ONoh/nBc7s17d.vN5nVi3JOiQAgVya5G	atreus.james
362	Jamir Higgins	371	3	f	employee	$2b$10$LC5bXC9uHhVy6QI1lG1QtOt9UGi05suRBdcPl1sRDvugMWfi8TvvG	jamir.higgins
364	Everett Floyd	371	3	f	employee	$2b$10$4u9WbQRJB/HyFhZVxtM1HOJaw5YAdpfcJmEZ3khSHF5ptj//ydLYa	everett.floyd
366	Judah Bernard	371	3	f	employee	$2b$10$6GKfsv0PjRoArv0d1j5Mj.XAvKN9dr0JOyLD8F8Dhv06gXA9oKX6O	judah.bernard
369	Oaklynn Hancock	371	3	f	employee	$2b$10$0TE9Tq6aY3pGv8vCUknEJucPal1b/v6sApecPIiaLbU2ysMbQ.85O	oaklynn.hancock
371	Mya Ford	391	3	f	manager	$2b$10$wuMVZFO/YWRxjoKhdWEXxO1Lu1OCEbPpiBjidrYH6ooBkdV18wFom	mya.ford
373	Taylor Shepard	380	3	f	employee	$2b$10$UdJqPSvbbEhfTcNK9svCtuADU3XGvDvP/Fc5BVmvrHl9jBJtME2G6	taylor.shepard
375	Audrey Terry	380	3	f	employee	$2b$10$POkZfNNeBqJ9J1Gy9kuAPu/9KtWjRtOB/31wposw8Pgwnu0RKp0Fq	audrey.terry
377	Savanna Bush	380	3	f	employee	$2b$10$MZuRNiAx/8inAnjrwXqViucgViWLmhv.HE1KUPHD2pSAGLe9TrWT2	savanna.bush
380	Tru Doyle	391	3	f	manager	$2b$10$kh4z5GPCPqQhfGvL7YBDKekccTrADvoKS3RSeqVx47Ezj/zerGLrS	tru.doyle
382	Jay Santana	383	3	f	employee	$2b$10$n9bCQLsOeJtrtj.9QV2bwutb4aVZxxoEnFdMAquZzFhgo7clrtnLW	jay.santana
384	Amos Lindsey	391	3	f	employee	$2b$10$Gvlk2lDleEAiFkSoZfYdIu.T8SQPiWebJW849ERRVzi63JhonuGDO	amos.lindsey
386	Wyatt Chung	391	3	f	employee	$2b$10$FcOH26msDSMp8mb2Y7pYZ.sBgZK2qd7KjSZnqUx9YyjOyzaCgNwia	wyatt.chung
388	Dax Acosta	391	3	f	employee	$2b$10$tEdaDRr1SsqIJn7mnsXXM.cdvpEfit4vEFxRFrmFI0Qf4dVYjIZPy	dax.acosta
390	Ryder McGee	391	3	f	employee	$2b$10$h9qMd5PR8fAdWau7Qiqi/eFVS7wtimIqDoWulDNvwrJsQclf0HiDq	ryder.mcgee
392	Kalel Sherman	409	4	f	employee	$2b$10$4wUsGmLmFOvEsXTLbXwvcuwIG5tiwdT8mWxhTbdJytrPjL3MJucmG	kalel.sherman
394	Keegan Bradshaw	409	4	f	employee	$2b$10$RTy3UtSIwQ7kQAkMfmJDpe4opvA00OF2kmO6lzvypLeFZtJ/yD4nq	keegan.bradshaw
397	Aria Callahan	409	4	f	employee	$2b$10$VqEONMyq0UkdvQc7pIr9FuH4tR1YxzhrkLjJhQ2APH417rBda/MSq	aria.callahan
399	Haven Trevino	409	4	f	employee	$2b$10$2GgfCho..RB1hroWfcZrt.h811m7LeGutnI0nToWC2RXJc46Enyc2	haven.trevino
401	Gwen Robbins	409	4	f	employee	$2b$10$lbN3XpNhwqZSyP2EV66K5OQ8jOpI7oIVqCcH7cvjTHNUJIW00MYda	gwen.robbins
403	Allison Whitehead	409	4	f	employee	$2b$10$5Kz9jPH/W2lywL/1I1iy3eO4F7tC2fuUHBiLjZTbFA/jj5N/J.ptC	allison.whitehead
406	Edgar Mayer	409	4	f	employee	$2b$10$r427rSm2MsqNK8L5HnE0JONXM6IGzJkN2VBvX9.YHGT7nnVqsF.8O	edgar.mayer
408	Wesley Nielsen	409	4	f	employee	$2b$10$q9UbnRXdK8isBvOWqvYrBOaRWVw3YcV5usAYvGTUvfcMhW1BcifHS	wesley.nielsen
410	Yehuda Parks	416	4	f	employee	$2b$10$DPRuFlfVgIHpxiDE6viWnOV7OqEwJ1kKio.N84yHWijIuFL5aYEVq	yehuda.parks
412	Onyx Figueroa	416	4	f	employee	$2b$10$DdT0llZN3mPcDX8DDnJfNOsHuq2qZ6Ffva1FiBsTnS3NpQVQuhXUe	onyx.figueroa
414	Layne Donaldson	416	4	f	employee	$2b$10$znInnZSG4IgV2fTuKgkapOOb2UcFu.i3hxfAr3RqNhBWA11Y8Hgxu	layne.donaldson
417	June Ahmed	423	4	f	employee	$2b$10$Svaa8x6cViXBowx0cVSmY.KwbxvXKuScFFUZWaT8WuEcca.mDxNbi	june.ahmed
419	Kamilah Bond	423	4	f	employee	$2b$10$9BYXp.JZGwDige6/NeQKCe8r4lacgBBM8FYbfSI5f4KIBlfP8l4/a	kamilah.bond
423	Phoenix Navarro	712	4	f	manager	$2b$10$NsKN7dd5LYZ9v7RtwxjcPeCxMy.6DjMh1a8lu5NW2rvRUWMCIhjv6	phoenix.navarro
425	Mae Noble	430	4	f	employee	$2b$10$uT9yNwxdHzfGUtjJB4Cp3.CC1F8a05bHAM.cjPfPVTNweeQxGmnpC	mae.noble
427	Averie Willis	430	4	f	employee	$2b$10$bw/1S3KtmqlAcnaqzfYV2.RXX7sVNnQCDWNNkMxjIcXJ/M4V8HiIO	averie.willis
429	Nyla Good	430	4	f	employee	$2b$10$BAl/pkMvqvN6M8YQ9E3Fh.TVAwgVi4fV0oj/hUGMF52EuDu/9bgLy	nyla.good
432	Carson Adkins	441	4	f	employee	$2b$10$kXB4ZxKIvQpS48Co0vlSRu8082WyJaIxz3GP3Gi0x5EoWVoW9QSsi	carson.adkins
433	Emelia Day	441	4	f	employee	$2b$10$6pmLvD4sRSyVKgKYirim5uWfRmm7j9YQOLdlIomyMnMddKqCanf16	emelia.day
435	Helen Manning	441	4	f	employee	$2b$10$AVO6qiZUw7ceQkTqNvWR2O.xMLGQ0hbFW8IAOD4KdMBPtF3edmnTS	helen.manning
437	Noelle Jefferson	441	4	f	employee	$2b$10$hPzKw8qui8QIBoo4FHGlyeqEBGFpJF3Ppin5BQvOJ8x7IU6LwOpCi	noelle.jefferson
440	Kaysen Barron	441	4	f	employee	$2b$10$rTbioE1R7X3VHtM1m7ne3.03PJClRHuzwhjNifFRHYchd3qDwB0qi	kaysen.barron
442	Van Rios	450	4	f	employee	$2b$10$JMBtu/Hghn46Gkt9C1cL9e6rbmaHrCRMKtudL8In1Y/GxzaMWzXc.	van.rios
444	Harley Wagner	450	4	f	employee	$2b$10$lx4MY8l8uy0WgC4B0rCaC.8yTT3gF6xc3sJ9IwyLxoRPBMuHudvq2	harley.wagner
446	Finn Hodge	450	4	f	employee	$2b$10$jRI2IJhtabhtA5Mz47tWb.1VJ9mfA98wWCY5XANSaXALnyT3HiUeW	finn.hodge
448	Kyng Andrade	450	4	f	employee	$2b$10$qzwj/QMBR6/2KgMItYDBteNkI/DU8ouyDs3l2evpvEG/elf0HK/TW	kyng.andrade
450	Casen Bryan	712	4	f	manager	$2b$10$x1cR/7ek4z0HaOFRPUgyluusSQPlMGfSFPB.7wKPSO4cATO7nPssi	casen.bryan
452	Mylo David	455	4	f	employee	$2b$10$pbsyYTPIzzyv/L2zOLK8wuFi/nh1lpEgAVaI1wbS6UXkSV5C9Pb7G	mylo.david
454	Eugene Gallegos	455	4	f	employee	$2b$10$WVNPf88hrCjikFPrTKznReoqZdjTSueQzXMdkvMU5.NOLKHVvCm3S	eugene.gallegos
457	Miranda Anderson	474	4	f	employee	$2b$10$y.u8Ovi2LdcZN.Sv2FDSs.pr92flJY4BV9/0wXJVy3FFcCfUYXgcW	miranda.anderson
459	Paisley Dorsey	474	4	f	employee	$2b$10$gh0n1/w0nM2QKYi5j9lqQObq.BfxIs9IcB7hwriqOKznOgAOHapV2	paisley.dorsey
461	Emery Cochran	474	4	f	employee	$2b$10$qFAbaGgEhzLqZnfHvQDvu.ZqAdmZATKQTLgiqhWmhJLIdHC6mg.Gm	emery.cochran
464	Damien Marin	474	4	f	employee	$2b$10$XT7Pl6b7EqoERBkgICNAHebuMmDHh557Eck1HkM67UlpSaqqSAK3G	damien.marin
466	Jesse Matthews	474	4	f	employee	$2b$10$lYk1oM4e2czkGIiKzw/TSuN0BoZwAYt8sk8weUQx9YOkPHkzmAsn2	jesse.matthews
468	Omari Elliott	474	4	f	employee	$2b$10$yneBy8KJSpT5fzlUWyEKg.LjvlTAo.LFEGEkxHrrtdSE1OiqINRzW	omari.elliott
470	Yosef Cano	474	4	f	employee	$2b$10$kIuCO5AINrwPPUA4kuh6meGVB.mDNeVhWD.r8MGY/Wdaj6HUY5dA.	yosef.cano
472	Corbin King	474	4	f	employee	$2b$10$Ixwz5j.CJC4Mp.2AmO5E8uqlycgCZ5dODjKwMKFAo5FqMM68GXB7O	corbin.king
476	Braylon Olsen	483	4	f	employee	$2b$10$wSa3bIcWz5t6Iubfr91s..8oPn8iOiNMagX8VBdGBSeaw7nyWmhsG	braylon.olsen
479	Barbara Hendrix	483	4	f	employee	$2b$10$TVtoZOlv9kI9owlijaGKp.MaJKYd8/PqM7K7RM9a3GFdCA.rPoqqC	barbara.hendrix
481	Opal Mullins	483	4	f	employee	$2b$10$rGEThGUQHgyDK9n1KmHMreTw8pVraD8SEvYiMP0IslWlcmPOjdgE.	opal.mullins
483	Hallie Freeman	712	4	f	manager	$2b$10$KjnjIWqnTMmpGuUeA5Sd0uvuLX6efNUj8wervoXUkzcsCQskjZsw2	hallie.freeman
485	Genevieve Mathis	486	4	f	employee	$2b$10$2rbcA8ujxYRHAuxipWCf0uT7siHBFRR.KOJIU5lMDlaZzqZRGKRw2	genevieve.mathis
488	Creed Ali	494	4	f	employee	$2b$10$zaFOFdVnHZtASYOS2lzWDeQtlrrdrSPn5KEvt8Vi0Cw027csk9wGW	creed.ali
490	Ishaan Colon	494	4	f	employee	$2b$10$ziClfRDxrvhRhlqHHzEpD.B0Smcw2H5qs0kI3Cwvm/ZKhWDXHlvJC	ishaan.colon
492	Samir McGuire	494	4	f	employee	$2b$10$fJeuTQ5xaZh1Gk.l.aO6uexbqXlHA.d7Ivk70COf7W0hCAMmiVyh.	samir.mcguire
494	Jacob Nava	712	4	f	manager	$2b$10$T2UrxK8KbDy7V3YDdBhT5eTMRf.ZqfKXql71gx3MntUFFJrcu8OSq	jacob.nava
496	Eugene Dean	501	4	f	employee	$2b$10$Wd/HyR5NIv9j7elvSRuiVOx81IEkEoKydBuVElO51XnX7h2msxTXW	eugene.dean
501	Calliope Shields	712	4	f	manager	$2b$10$r9I3KfvVY6IRut6i/iHsFuMJW/MuN2j1.39Wv6/Xinbjp0OTjS3Mu	calliope.shields
503	Iris Berry	507	4	f	employee	$2b$10$paONmd62UWRcIWVITctSxekaxwoUvhPILo5XxZoYL/l2uFJU3JxDi	iris.berry
505	Renata Enriquez	507	4	f	employee	$2b$10$CL3UuO9DPgPPcIpnajmWEeS6v/mbQLSiE7j5GJR4v2CkgqIHO6wcO	renata.enriquez
507	Mabel Cole	712	4	f	manager	$2b$10$.U0TI7cdgMJga.bfDMjgGO5R7wqCe4wwW3VCaDVyY6GGVmH17NjBi	mabel.cole
509	Ansley Petersen	514	4	f	employee	$2b$10$fibImn4FAQmzaDog.t70jufhESpYUpP2s6ZvQiExmxIuPS3cR8ori	ansley.petersen
512	Eli Wallace	514	4	f	employee	$2b$10$bjl9kNiNhkUsmIAHKS4C7e5H/Cb.8M0i788UmE4zMziHljUwJYUvy	eli.wallace
514	Isaac McCormick	712	4	f	manager	$2b$10$OZr.tv9sYcfB6E2hR67mau03yGDx0ufAAQKTRlw7BjWJFv9SwA6ye	isaac.mccormick
516	Stefan McPherson	521	4	f	employee	$2b$10$6/VZ1ArM5kF6Q9xGyGa2t.fA/Jb4vVSjCouAfGRjgrO0SgjQN7PCe	stefan.mcpherson
518	Nelson Haley	521	4	f	employee	$2b$10$RB99uypLBtYCad2UcYLSeOD0cw72wDnaFVupLBufmzWvYbUJp.Y0y	nelson.haley
520	Griffin Dorsey	521	4	f	employee	$2b$10$yDi2Zd8PP2RgnO31IaeSeuzy3VcdWel9cMfJ.WvKGontoRUq3DdfG	griffin.dorsey
523	Caroline Soto	532	4	f	employee	$2b$10$sq81P/7O.6OFa7R77.e0FenkejGVcfohAkxGGRQR9jOr6ZN.K3Amm	caroline.soto
525	Emberly Sawyer	532	4	f	employee	$2b$10$fzcxbpaqX/WxxXTCDc1iweZTAdQVe.YMgPmdqzhzzddF2w8L2WGU6	emberly.sawyer
527	Maxine Arias	532	4	f	employee	$2b$10$1vjVLsxrPECb0Vp9MQRPjemIMdE8zIvu96o/HskyGJS0Bm2nJP.dO	maxine.arias
529	Giuliana Craig	532	4	f	employee	$2b$10$.4T97xzPAR3jiaOVm63ee.PtcVjB2nhR6GmkvAd8BSo0D1KX7T/wW	giuliana.craig
531	Rayna Pruitt	532	4	f	employee	$2b$10$bcQodu3yH.lZfu0rQZb9be3HEGuw3qcStDW1Aaad/vJWyrgYgMij2	rayna.pruitt
532	Gatlin Palmer	712	4	f	manager	$2b$10$N4a7Waa5JBMRW2fBI4J.WuMkCmhVg5cAeU7QkD3lJ0gGypv5JWNrK	gatlin.palmer
535	Isabelle Montoya	541	4	f	employee	$2b$10$bZuaYUm8HdU2IDIJhlXeQexOmPf3ZtA4kcs2yklSAaPo8ljMO9VJK	isabelle.montoya
537	Mavis Medrano	541	4	f	employee	$2b$10$h3TkNvqOU0l9ap9MuQSmB.dW.M6BfvG8K7x94aWll4jra065OsGdq	mavis.medrano
539	Alyssa Coffey	541	4	f	employee	$2b$10$kpsLjeuqjHASmJ5LapfroOkhcLnjU/F.Jju3/SBJJkZpRJQb/3v12	alyssa.coffey
541	June Conway	712	4	f	manager	$2b$10$dTlRyZERBn4LqZKRBgDZTO.RM2I0JODpjiQTo34q/MqzUYS6YNs5e	june.conway
543	Zendaya Morrow	546	4	f	employee	$2b$10$w90sKfq9fdxE4vkK3FtL9e4yn/pctMtS9AnAa6HAgE/lyI8cljpL2	zendaya.morrow
545	Alayah Watson	546	4	f	employee	$2b$10$4vxFZGY8YuHnHvK7A46MpujEFD05R0X5TJM3ZauGqK5jyPJ/FTaRq	alayah.watson
548	Jonas Shelton	565	4	f	employee	$2b$10$50zQU14N5J9FlY/l.oZZHuMJ0rAc9cwYqcwpNS/nHPIsoUEomPATq	jonas.shelton
550	Chandler Salinas	565	4	f	employee	$2b$10$mh66MHisO0cK.GQMv2Z3J.6PDFYpGyIU9qaItmaDzKMmht9fe.Fgi	chandler.salinas
552	Cal Delacruz	565	4	f	employee	$2b$10$ngMqSfMV23oMPJdT9BnwqOmt9KhVROsdveyp8L60J0BVcjPsb2AMy	cal.delacruz
554	Gary Ware	565	4	f	employee	$2b$10$9QZY3yoYQNSDQC/xhceQUuqgEytZslM7B33hpp2yAJWXgBzrTGTde	gary.ware
557	Juniper Ventura	565	4	f	employee	$2b$10$cTyHICZ/2t/zneI4yscpvezCF2yQt8i.1vnsxtDTrw6VyjJwoqLKu	juniper.ventura
559	Emani O’Connell	565	4	f	employee	$2b$10$5/Koay2NNqzU/gQvxSg/hecMfD3syz6pswkdJ8QGXJas5YK9ci.1a	emani.o’connell
561	Juliana Landry	565	4	f	employee	$2b$10$KzswhIhdZHRYCYhQie0XmOh/gTWw5O/oWGpJkRRJZzWrzqYQeijKi	juliana.landry
563	Kensley Buck	565	4	f	employee	$2b$10$IilmpGIEgS3MDRFjU4eLlOukfilbgLSnBTgQ5lBWELdjy3RkhiEsi	kensley.buck
566	Kody Wright	574	4	f	employee	$2b$10$Yyn9aVqNSQtj2ZhcBUaDsOss.s8N69B7d7IaV9B0EyuqrJ22oloWS	kody.wright
568	Quinton Thompson	574	4	f	employee	$2b$10$jb0MpwTl/ZYrQzKCcPB19u35YbFXMILlPSuFs.rPj5KFoGzTnnTFq	quinton.thompson
570	Malakai Walters	574	4	f	employee	$2b$10$jptWlA1WBy7rCMERuADA4OxOi0dtkMCj1XdB6UahdWDvkqAMgPeCO	malakai.walters
572	Israel McKay	574	4	f	employee	$2b$10$2yOXEma3GJ9dXhgW8HRtw.JZvPMHdpKvDy/UbrMfNHBOqvYd7/R8.	israel.mckay
574	Sage Corona	712	4	f	manager	$2b$10$.HF/xT6ZfKa462Z1flFZaepdmgFOfhWp5JzAtGXmwUGuVF80oHj42	sage.corona
578	Watson Williamson	585	4	f	employee	$2b$10$NGUZECKgaVI4/C23sI2AnO0/95GfNP9CLfueV7iTjLqeKLnPQ7F1G	watson.williamson
581	Marley Gregory	585	4	f	employee	$2b$10$u.vCrKqDWY3Jjvby8E/OtupV0tArOENwgLPaoNNggTIdEMEV67oDG	marley.gregory
583	Trinity Colon	585	4	f	employee	$2b$10$8t.cH3ouXfKXhCabJq5LUOK6XI2nF5Nb7F70jR4mqDxJFRJqD/d1y	trinity.colon
585	Paige Duncan	712	4	f	manager	$2b$10$EfSXNfzNT9Yq0BpcbCN5Zeng1wCCU25EhkJlBmk3mb7QI0ZvAGZOm	paige.duncan
588	Remi Portillo	603	4	f	employee	$2b$10$TEvVY2Ty65ufPQER3GGFE.gixxRAGFIwXIXp.nNk3C8BvIy4TCDaW	remi.portillo
590	Manuel Barr	603	4	f	employee	$2b$10$K9ZGKv/GCG.s5qGIsLwjHODdKNVFnx/u0Ze1.B2DawhtuH6kJ9ogK	manuel.barr
592	Santiago Simmons	603	4	f	employee	$2b$10$292wvIrPuMLqVw4Gtb/Bq.qjAs3g2ZyD80kLkHbn7ttxlLMK4Nrwq	santiago.simmons
594	Marcus Hester	603	4	f	employee	$2b$10$WAus.0Vu/sX.vHlua1eG/uBC6WgKGrJvvonV9d0fBSf0d3v4en/RO	marcus.hester
599	Everleigh Pugh	603	4	f	employee	$2b$10$7XJ3EgEDpFLQX.q7g/jNQ.1livtGVOw7N3Gfjj7xkNvTgjs6fiJwm	everleigh.pugh
601	Amelie Quinn	603	4	f	employee	$2b$10$TsUtWqsHAZtL8qrpiyczgeYqGp.lzmGnnRqbFPqDT3M.gZ.hj0nta	amelie.quinn
603	Jaylin Hansen	712	4	f	manager	$2b$10$qiYaVrXhGHvnEPMbKnCICu0NPev61lt.EwnR3aMdUJ4i3FMk9K6Pi	jaylin.hansen
605	Kelsey Cantrell	610	4	f	employee	$2b$10$LC3RnJuXlIGDNgEdblDMke3JHMn.b5UWACvWK.Ib8qXtu9N23.Csm	kelsey.cantrell
610	Gregory Doyle	712	4	f	manager	$2b$10$ZS8kjkLa9uUG1ER1P15lj.Ac6teDjwNEHInTh/oFT/prUbV39vQe6	gregory.doyle
612	Marshall O’Connor	616	4	f	employee	$2b$10$nS3O2MYCpivpzmobcD6UgOIhQd8g33VsiyuWQ/h3lBvG.i2KNoyxq	marshall.o’connor
614	Osiris Price	616	4	f	employee	$2b$10$XgIzY8pOPSQ.6kxQRMf4f.8X9cCsK9HpyVKaSb/r9En0309HWAKSK	osiris.price
617	Amoura Olsen	623	4	f	employee	$2b$10$vg57PJHSiGbOfXTkOGLp9OA2v2Fx5yOQ64abjW7r.6QC6Bv.4xKT2	amoura.olsen
619	Rosalie Potter	623	4	f	employee	$2b$10$nKzP6diq53To3OJ.kjQQe.bv92EuMYhxDTqWr87hutPE82dRuM0jO	rosalie.potter
621	Mackenzie Krueger	623	4	f	employee	$2b$10$.s4LY4pWlNR0EWbA8Sr/KuQn9v8b.OkmBi9IRzJu1rf7Fo0M5dZjW	mackenzie.krueger
624	Cannon Simmons	630	4	f	employee	$2b$10$ng.sgXuGTL9T4EypmjCH.e2uY4rQSrfUpgwrjMhetxIZqQ610ZZLC	cannon.simmons
626	Elias Skinner	630	4	f	employee	$2b$10$er40VvIgyCnzN4mWgcJS9.1ngEFr3OETl2nCGl07W9m3LbzW1BI.e	elias.skinner
628	Branson Barber	630	4	f	employee	$2b$10$4mlUaOfQKmvs9gNKgUV5fOOnqJDN8LIzI2n0fT27Qfab8TK9PPOSS	branson.barber
629	Cassidy Dyer	630	4	f	employee	$2b$10$MY4FDdu8NGXz3li2tyUBDuL6/dmKr2uqdKMPxwGETuahS.nqXgMqa	cassidy.dyer
631	Ryan Mitchell	641	4	f	employee	$2b$10$F3eoN64qPT.lIdBXi6T75uqbTDNUbCxxQZxeJIZ3Cr2uzQA0tX7g6	ryan.mitchell
633	Lyanna Guerra	641	4	f	employee	$2b$10$O..ZSo8J9GYBSwZrZ6FR1eNZT18glim5yaMQroeiKLEAyeSRNGuAq	lyanna.guerra
636	Graysen Powell	641	4	f	employee	$2b$10$Huk6O1T0tYGM55TLAXzqAeiEv8/WnvB.j1bA3eZfRA9w/H.FLTcXq	graysen.powell
638	Kyng Stout	641	4	f	employee	$2b$10$zxPv5W7IMBN2lO60uM.BX.BYnwG7a4h4qittesi1dvTiKfeE/jDOa	kyng.stout
640	Kieran Floyd	641	4	f	employee	$2b$10$HAIPoz9QySTema8LG6W8tOQl8k1k9nNGqLb.2eD3ge8YEopUapmci	kieran.floyd
642	Andrew Conner	650	4	f	employee	$2b$10$vvAkwC.YayjodyLwDnGniepnWv1N/JV.Z7pLRInaGlKibFBCTk6HC	andrew.conner
645	Laney Gould	650	4	f	employee	$2b$10$Xx5BSb0/Irs8iZFohHhFie5bF9pwsREqYcmgJej6np.KTDs7HOVgi	laney.gould
647	Aileen Perry	650	4	f	employee	$2b$10$egZF1FOIixRzjeWVX/k9seA.PL57KkJVc5CdeoVVojUKeQFdt3cCC	aileen.perry
649	Hana McGee	650	4	f	employee	$2b$10$BbjTuIpOysyqbYa2i11FgeXKOgAul9Y/EzPQVDMAqwmnFlA4rmaxG	hana.mcgee
651	Keily Avery	655	4	f	employee	$2b$10$5dX0tvGr13VdWQHH10sxpOxznr8nSPjTM6maJ8yccy3aMmpogRvAq	keily.avery
653	Ella Travis	655	4	f	employee	$2b$10$jmtG/BzeKkSq/5/6/2N/COCcXYg0O66pvrT.mIVe/mAAFpN7PLUri	ella.travis
655	Remington Anderson	712	4	f	manager	$2b$10$AAyiMQzi11kAY/2JVMP5AeyXU9seGv.8kEqi.H8O.FTPvrrkszBr6	remington.anderson
658	Kyler Johnson	674	4	f	employee	$2b$10$77X1mvuchPLb/ov9q11VKevtR3eUEVbV80TNiA0SJ6kkAdHRe/shG	kyler.johnson
660	Azrael Reyna	674	4	f	employee	$2b$10$7SPkndXjLxv5dy4Z7upwTO/uugDXtNfUpIzyV8QQ8vy4xv2bDd8Jy	azrael.reyna
662	Jayce Washington	674	4	f	employee	$2b$10$FA0ZNTkfjAvmgwUD5yowgeYAQncbymLMoeDSzlp34QhSRYzRB.5QW	jayce.washington
664	Will Larsen	674	4	f	employee	$2b$10$tgeb5LoEEcgdQLn.mjdpIux9kkHgtpcf739sBiC20hkyaeKt482p6	will.larsen
666	Maurice Beasley	674	4	f	employee	$2b$10$76En6IEkN/OJNLjmi7OVLObTNxpwYcgORBjoWyG6Ewpt38T.CTKpG	maurice.beasley
669	Maggie Quintana	674	4	f	employee	$2b$10$2iqqFsOOxHdB/RIJVb0KGuJHIo1fgNKSBFAmYrI5w4lEJwIq0huje	maggie.quintana
671	Camryn Thornton	674	4	f	employee	$2b$10$3vCdFXW0AzjXoDPSeqQrweuPA4YgEw/g1xszzoOjgPgG2Sr3O8LNS	camryn.thornton
673	Kathryn Christensen	674	4	f	employee	$2b$10$fqAgIkeoEL1GAmeygFcypuv9eEN39mmL8JceWfIw3ALEch7ls4BAy	kathryn.christensen
675	Zainab Greene	683	4	f	employee	$2b$10$EG3I2Llmg1jLSlFXcK2yC.4A8DBIgb0F3Pv5Te4YrbTxuftsPY1K2	zainab.greene
677	Kamiyah Steele	683	4	f	employee	$2b$10$HWES0XbowSz40Ra5C4Xd8uJuZjgT8Ng6Ohy5kyT4K5v/Jb5dKGlk2	kamiyah.steele
680	Brixton Avila	683	4	f	employee	$2b$10$YRzk5POf2ghqapHo/MAvtuw/.UUFXrccNQBrB6VIEw1FqYCFBzKmS	brixton.avila
682	Harris Stephens	683	4	f	employee	$2b$10$Ywe40AikWvCLzsDg94KgP.2ySJwBuhJ7WAPy.n01jVotcHmwW0ZPK	harris.stephens
685	Navy Nash	686	4	f	employee	$2b$10$ZDTC51e12HgczIPBCtnZ0usz.tcjefSjIj7bSEXTNsOzoaCp80BWy	navy.nash
687	Avery Russell	694	4	f	employee	$2b$10$uoMP6iHP/tq0Xf7BIjNpMuoAHTfsD.UPTVpDwg00WnBtuDcX8DjN6	avery.russell
689	London Rojas	694	4	f	employee	$2b$10$EPWhPnyhFJZHQAHiK8FhK.WozJWboeBlnXOIWeZC0tsbhKGXOom7q	london.rojas
691	Zaniyah Wang	694	4	f	employee	$2b$10$MLfD4f3aW8zkIRfcNuewtO80q.11kSsFPj6v2txVlcVTZ4CubigOm	zaniyah.wang
696	Phillip Cardenas	712	4	f	employee	$2b$10$PC0yAXQREibCwKxVjFRuh.fq4cx6hl95kPm54BDb.o.itdO4qbzeq	phillip.cardenas
698	Kamdyn Dalton	712	4	f	employee	$2b$10$EjqoDGKORrzd1jQf.t09EufVpsMGHHikS515vrdnFRAys6WJZieN2	kamdyn.dalton
701	Siena Berry	712	4	f	employee	$2b$10$JveqllvO1uU2tbmAY9IS8eP2GS5SkxixQKIpo7ZO7Slc8gn9CsTKO	siena.berry
703	Aurelia Rivas	712	4	f	employee	$2b$10$PsWazdjrhkwt3RwvzTnMFuzSWu4Lf2FqHCxWPOCCJaB5JbF9yDxDi	aurelia.rivas
705	Elyse Pierce	712	4	f	employee	$2b$10$dYAazfg26zi.AvvTwDebc.6rnCn3W5hU1Ec8.MRlSSPsVo0QeipdK	elyse.pierce
707	Ariah Hill	712	4	f	employee	$2b$10$Rzi9zF0n0hOHB67Mj4lxA.Vqktgn2hqWFmAEFLSIaNi4qE4/0Ks0e	ariah.hill
709	Holland Miranda	712	4	f	employee	$2b$10$UbEFrghfwfga1NwMX1Rhs.SsSnJ5dmydFprTf2qxNY7mTrZ9TPj2S	holland.miranda
712	Jeffrey Rhodes	988	4	f	manager	$2b$10$mO.K4VIwgNIR6h3G8lKcwuAH/HWaPCVhGeU16q3Nm/vcP.pGFBfCW	jeffrey.rhodes
714	Robin Bonilla	719	5	f	employee	$2b$10$iRMlTJDvM/8sl1VesRnCHuWhN/JtKXB67W.PfVx4dG0KT27aNiN36	robin.bonilla
716	Sullivan Vaughan	719	5	f	employee	$2b$10$lFn6DkGnw6gEC/sHmlPyO.HIWnuc1Ucu1dvvKvzrewiS12gigXyi6	sullivan.vaughan
718	Brady Cox	719	5	f	employee	$2b$10$5KASjInJMEg9prWM4wBlU.SUDJkq2iLFYuHt0r0qRiPgmsc8tLJdK	brady.cox
723	Melanie Bishop	726	5	f	employee	$2b$10$Aa9qq1W4F5fdVY3cGiKG7.RDudZk1nSmI5r2Xm10biYcB9rvYRPgu	melanie.bishop
725	Nyla Kelly	726	5	f	employee	$2b$10$ge2XahoqR6JvdQH2LccJ.unAtd/ueduuIKAmxBqRmQghkeihTdXuK	nyla.kelly
1	Kamryn Villa	8	1	f	employee	$2b$10$lMAk8IqOWZmIqPqKs4a4X.iJndNlWs/MQQJ3Faf9VUfkZGoCLOY5y	kamryn.villa
3	Paige Santiago	8	1	f	employee	$2b$10$Gz.ECNJi.Qr3URqIgt43hevpOw0pNYmd78MCorRHHgi5prn8Y6722	paige.santiago
5	Rosie Long	8	1	f	employee	$2b$10$77e7EP./bqf/f26F8kyeMuUhwkJCBThV/tXJzFXi.faf0TYpJbhGy	rosie.long
7	Alani Sandoval	8	1	f	employee	$2b$10$ZJargk1SAVRXLMbQWyau8OjzEzOD.4Dbm8S1Mh2emBLR5Z8b2rVIO	alani.sandoval
10	Dawson Fox	14	1	f	employee	$2b$10$HXc2zYZFgzwaWKikUDauWeSHrzDaZNbRG4wxuFzVXrzHJwml4UpcC	dawson.fox
12	Albert Eaton	14	1	f	employee	$2b$10$regIyvCfnTAP6lGoVAjPOush4BjZsNoCbXdCjXX8/7SFwZTtMm6Vm	albert.eaton
14	Cullen Nelson	40	1	f	manager	$2b$10$MQAmxNYtCZ6AnoaE0oBK9e.aPoVfPEg./OOmPTnly.TDks9zORqA6	cullen.nelson
16	Cassius Guzman	21	1	f	employee	$2b$10$KQaP4Xm9xoxU5eRkQaK.uOrHwICoQmEwoyuaflf6glGGYhr7d3eW.	cassius.guzman
19	Marilyn Bernard	21	1	f	employee	$2b$10$G9gmKvZUa1AQFMMtejEe0.WXiB18mZ0dm6Mmh2YFRbOUKbYMiWUeq	marilyn.bernard
21	Oaklee Chung	40	1	f	manager	$2b$10$HLm9HehVkHli9Zw3w2zhmOf306i7NwDj8837IT9xuW.CtoQ4zxyra	oaklee.chung
23	Sylvie Stanton	28	1	f	employee	$2b$10$WsPaVaGJl3I8HI3KdJ79N.O9YV7xRxL/Ttt/XRME9m8mGopsNaGWu	sylvie.stanton
25	Aliyah Madden	28	1	f	employee	$2b$10$0AydZT.cY.tDGSxYKsWneOOStfe8R8M3hWluocONscchEX64W9LgC	aliyah.madden
27	Ellie Gonzales	28	1	f	employee	$2b$10$5lgSCb01JkmRqYHuS054TeGzXhf33UDIzThLk/UZmZSxKQwkoJ1e6	ellie.gonzales
29	Payton Chen	39	1	f	employee	$2b$10$YD9mvsj9TQ9.R2PvMlviGeXkbAimNd3Ppsu/jMlFBD62XvcGJJUuC	payton.chen
31	Emmeline York	39	1	f	employee	$2b$10$59JazFM9Nc1CvNyADPDTY.GGCCHjQovWeEIVZaZkhWeGkZkOqfR7O	emmeline.york
34	Valentino English	39	1	f	employee	$2b$10$EVhbQtSBSnCidemvhBOvbuEh8Vly7Zx/Uy5qVjd4cczYdDszZ/hSC	valentino.english
36	Ace Gould	39	1	f	employee	$2b$10$gSU.JVl8cghAEjn1.jzQW.v71ZyNJ8ZGeDgAYATmJI72HwXi3HYWq	ace.gould
39	Marina York	40	1	f	manager	$2b$10$TPlY/MJ.2bEwi3nWuKzAvOWq8kZ73WRiGyi71B0AQ9tdhRh1E0uhG	marina.york
750	Nova Villarreal	753	5	f	employee	$2b$10$91X9PJaFIgIFcUbRhCkjvOUikkiCsClCfDvvSmpdG6V58VCwakjW.	nova.villarreal
751	Jazlyn Villarreal	753	5	f	employee	$2b$10$gigW2Ldd8fMbYd69qEYv/.lQ8RtFP4/87BQQ7MSyD.4M7RE3r/L32	jazlyn.villarreal
754	Harris Doyle	758	5	f	employee	$2b$10$ZbjbBqUG0Sihx5K22YaPc.gcd12/Zatdst/WKa3SK0EHaBT2K/HvO	harris.doyle
756	Duncan Wells	758	5	f	employee	$2b$10$/Fn1A./75QDm8Pniy0Ayk.Bq/oWSTTWlF3RB.tmcsEmX3zdXTmu7a	duncan.wells
759	Emani Davila	777	5	f	employee	$2b$10$VLSYoNy/bMu5xRoGMRbH1O/JMWZzGvGIJ1TjfBj.amxDBcyeDPp2O	emani.davila
761	Raina Evans	777	5	f	employee	$2b$10$fxlqVfmKwMRkzIXO7JyvY.aiSEvW4e.hDHxRjncPm0ewInMFbymsS	raina.evans
765	Alia Barnett	777	5	f	employee	$2b$10$sd/.D9trMdbrBd/IKoxgIONpKAlbSAcNjBW9zelRlVkqIg/D0GQnS	alia.barnett
767	Yasmin Sexton	777	5	f	employee	$2b$10$zCMSxgUvY6znPzV.ezj39OSzczuK0Ji79rJBlUeH2MPpEQo.Lj60y	yasmin.sexton
770	Eli Rice	777	5	f	employee	$2b$10$JAJffeo8scpaH5VE/tHCU.5zSviTT1nv1SGV4uAlo1BfZFTGjIVQS	eli.rice
772	Maddox Lee	777	5	f	employee	$2b$10$bxSkHyF.dsy83j7tiWbndu1XI58eADAllayWu9M5ymeKc5CbdYsTm	maddox.lee
774	Emilio Schroeder	777	5	f	employee	$2b$10$QkGOl/1y/ZYQV3gOhlrUaulvBIYihq/plGFoLWBtim/0WXb9jaoRe	emilio.schroeder
776	Miller Liu	777	5	f	employee	$2b$10$I8HHQZ5zYHE/NhrSYebKXuhAO7NkBPp0Qycz/JBH8.s51iJ82ioya	miller.liu
778	Devin Palmer	786	5	f	employee	$2b$10$ZpuPWUnvNZlTvyQDrEtzAOGH3M1KdUqGvDjNAn6bBrnM2RE7z2VQG	devin.palmer
781	Kaylie Kline	786	5	f	employee	$2b$10$pcNI88IUep/SoRbBQaYqeOjDoIoQXsztGh3W6HfHtUVECk9GlOE/m	kaylie.kline
783	Marina Hart	786	5	f	employee	$2b$10$AedyV31nX/uXjD2Ao/5Wne2LoHt3rcvHITW/J0bQsrv/hzfppL2o2	marina.hart
785	Kayla Lawson	786	5	f	employee	$2b$10$sJlFVGMnkprdt/kMpJzOSu9VkhZks7U/Rgtr3Z6G5YNR.fYh2I50a	kayla.lawson
787	Sara Wise	789	5	f	employee	$2b$10$ZG1kZeXriOTgodOwnyJpM.FyNIYJAOeYg4FnmvyjBChvnW3mMMUWG	sara.wise
789	Kylie Frazier	934	5	f	manager	$2b$10$tih84BUOI53gwWyubCN9NOLmX1rYRnCV8it20TDGk9kcpik8yFSBK	kylie.frazier
791	Tori Wolf	797	5	f	employee	$2b$10$5cQQs48WQM0DrHG8SgU99uH3DCZIADWT8kL/hkVB2WGzftkeORWJC	tori.wolf
793	Elizabeth Ortega	797	5	f	employee	$2b$10$1saxUtCCRZeRSgG51qBMi.ec9uLpdQ107ZqD9b1iWdbLQk5iZI3eK	elizabeth.ortega
795	Clementine Burnett	797	5	f	employee	$2b$10$MffhJVyzhbvgjrMLpwzil.A0Hl3t3MUuy9SjCB4T6OLNmauIS60g2	clementine.burnett
798	Moshe Garza	815	5	f	employee	$2b$10$RnuhnHFAM2OEehPHzIva3.FChP93AWcCZqvlLp2SwoMXZtyK85lOq	moshe.garza
800	Kaiden Chandler	815	5	f	employee	$2b$10$BKlKtxaUJZJzYvBjrAZBS.k16E07PxGRE2Bh.Z4N1WIEGDAL4A2xO	kaiden.chandler
803	Selene Terrell	815	5	f	employee	$2b$10$0BXP/6OcGQ./L8seAvyFCOxoNEHQ4TGWtPIwzMmQ7eqY2EE4zK3OO	selene.terrell
805	Kayla Bradshaw	815	5	f	employee	$2b$10$8F5qTXJe7/qfvlRDYxJPxeSY4h.2E1wvTzXZ7sbaGA5YXLQO0rGs2	kayla.bradshaw
807	Brynn Mejia	815	5	f	employee	$2b$10$h/IQ3GZZCYakluSR7ECWLOUQ/p/UQRErXX0JG6o6P6l2RhxY/zZOW	brynn.mejia
809	Loretta Holloway	815	5	f	employee	$2b$10$K.8MZy9iUeOjFEnEZED4uONNli/EUkPDyl/QSux.W8oHC2p2z28Xa	loretta.holloway
811	Daniella Rivers	815	5	f	employee	$2b$10$5/MfcFMevS.ZIy3z0l6eXOYQ/eLL7fvz5S1kJp5027qieop4/Niaq	daniella.rivers
813	Elyse Schmitt	815	5	f	employee	$2b$10$.ICu0jcmkRwzdWBFZk82nO/q.Ozo8HZHeGLIdQxDt16f61T93iFiq	elyse.schmitt
816	Joseph Fry	820	5	f	employee	$2b$10$J7AFMA.G7mMlFITlwCifGuox/jK3u/IKMtfMJuOVqnZF5GSmTIznG	joseph.fry
818	Yosef Hunt	820	5	f	employee	$2b$10$xJtnKR88tLCxwcT3Z06uTO.425xr6ppkDm.RVhDBsFwXee2sSzegW	yosef.hunt
820	Roland Guevara	934	5	f	manager	$2b$10$TjxQwuFUawNqJzqldkRnn.fQ1eGAafGZqZwfnKf5YJUxbhc6yyROK	roland.guevara
827	Itzayana Walter	831	5	f	employee	$2b$10$hy77L.N73fisvqY/BGg89.50n/pdTSZCxYOMltgEUMJT9KKihOkWu	itzayana.walter
829	Finley Marks	831	5	f	employee	$2b$10$WvBtQJYDWxgSXjQQDrsZ.uP.SaJ0Dn/aekP0/85/J5xr4WpLbj39u	finley.marks
832	Alberto Gallagher	840	5	f	employee	$2b$10$MQffQ//kDJ7/4KT4gWP1Y.Ktw40iIgFk0m./6D.LyNfWXthCtW3c.	alberto.gallagher
835	Shiloh McConnell	840	5	f	employee	$2b$10$I6bwCFTRFPdmp9XOfZa/s.DSjguJmDGmFm4ATvf509oyw/2pcjUP2	shiloh.mcconnell
837	Paityn Martin	840	5	f	employee	$2b$10$tqBYxZvpuhIRhOOuovu3NuFMN9dg5O5rLgd0QO1IAlyeBlWWlSCUq	paityn.martin
839	Alicia Lee	840	5	f	employee	$2b$10$N7g69RmQ2JCJ46dt0XhaTuYzzwR/AdGpvv92nsgkuS/LiLVxmUCc2	alicia.lee
841	Alexis Yoder	845	5	f	employee	$2b$10$CUDwTCDZfwA3zupH24AGHOcMxqBge43/RZkBew1StI04TBOwTVqui	alexis.yoder
843	Theodora Andersen	845	5	f	employee	$2b$10$3SsbB40hRNTnLVOsnf/oCO5tecdw6zsK1wdWV6lbCk/7xGxlty0/G	theodora.andersen
846	Kingsley White	864	5	f	employee	$2b$10$d0RbhJjmdJMcJq6kTPC5UepEeQOKQsE3rgWYIrFSq1X93xmN5a7IO	kingsley.white
848	Zayden Arnold	864	5	f	employee	$2b$10$T8qV9LdpxWPis6IBWePu0euLBYoa/YmJnXdb3.qcr8XJ3BhyDH.Je	zayden.arnold
849	Finley Hubbard	864	5	f	employee	$2b$10$1f7c2YXiTjWgPT952XuJpeGr3sfsD0LiCZjRJYW64NUufLzjLJhtC	finley.hubbard
850	Forrest Mason	864	5	f	employee	$2b$10$0d9.p.IUA9ipDd820cHIuun6l6B1LsBdJ5r4g9fcNNW//AlR48Ore	forrest.mason
852	Alden Le	864	5	f	employee	$2b$10$0bWQHFQxk17ko9YcdvXtmeRzITZPdJnBFhSrugXZpI.Emn9HxUyPa	alden.le
854	Ibrahim Espinoza	864	5	f	employee	$2b$10$4NMESGqczadsNGEYUOrMvusFL3VUS3mgNHASbau2P/LX7YvJ64Bia	ibrahim.espinoza
857	Ryan Houston	864	5	f	employee	$2b$10$Tu9zxXPiocS7XSAk.SFTpeeHLDqdxhdfq/bkZ33GOn/I7hh7AY4DK	ryan.houston
859	Annabelle Kelley	864	5	f	employee	$2b$10$KfBlSKnWN7IRfFJZHMk1JulyMoEdmI0XRTpci3/7qWldKx5EW.T8W	annabelle.kelley
861	Delaney Parks	864	5	f	employee	$2b$10$KwOCmcyJHfuvc12tO9dcy.JqQXHqvU6iAPlbVog7vZuIPP3rn1vkC	delaney.parks
863	Catherine Hawkins	864	5	f	employee	$2b$10$i0U3DcE6oc/0s9QW4sRhBeSw6EUAwWQYXC9vAn2.ZDp4EIWRtuE3a	catherine.hawkins
866	Shane Thompson	873	5	f	employee	$2b$10$bkvKOd56AumAQZfDsOTil.7Darj16uiN9..HsG7yCtc2yWvR0kHxy	shane.thompson
868	Omar Berger	873	5	f	employee	$2b$10$/nn62t/rol1262yBBL1rg.VU3uw8RMe2KQ09rlzYT0BPNZ4/hG9xe	omar.berger
870	Asher Mora	873	5	f	employee	$2b$10$Wv5g5R6ky5fwnA7AuYcaG.wkj4ZxnQYcYzR/Tkdl29l0d4uuQq5vC	asher.mora
872	Lyric Stephenson	873	5	f	employee	$2b$10$V6nhbRZ7LiKzeZvrRP92Z.XmfGs5f8EZbW10t1E2jypSd9ggTKtpO	lyric.stephenson
875	Pearl McDowell	876	5	f	employee	$2b$10$Rs000e.Dg1NvhnnJhi/aGeQvgHZTTG4gKLa.M2Jzz8feOXzqEsFVC	pearl.mcdowell
877	Lyric Gould	884	5	f	employee	$2b$10$Q76y1BXIxlD9wsulM9wRDe/BPsgX6oDh4yRgTXdJkYqTBhg3XMfTy	lyric.gould
879	Oakley Chase	884	5	f	employee	$2b$10$13KAnj1UIEFY4ofR4e1DQeWZ7Z8oE7tymSt7GANEboxhcew3nzIhW	oakley.chase
881	Mavis Cross	884	5	f	employee	$2b$10$xGcfUjuR/BXzJFAewaV/3eydoBSsYmSUciDwYoFF764DWXcO9B5XG	mavis.cross
883	Amirah Calhoun	884	5	f	employee	$2b$10$QNCmPa8cpV9NlL65U5d3GOV6pKAQ4KvyKH02wgS2ylaqZkuaNU4R6	amirah.calhoun
885	Cadence Le	902	5	f	employee	$2b$10$q/4NuynTVtLaV1RUOC9Iqu.y2DsqLfEpVvxMrPq4oWBeNbHEN4pei	cadence.le
887	Aniya Frost	902	5	f	employee	$2b$10$IH3IhIjp9hlhoYHGwBxPK.Y6Yp5Pj96bZvxtFdhzDZY8lm85B9Xjy	aniya.frost
889	Amari Fitzpatrick	902	5	f	employee	$2b$10$/WOx4p2OHCrUJqupo6D77e86VmKKS07ReaSCm4mGJYiBoB7s./WiC	amari.fitzpatrick
892	Talon Villanueva	902	5	f	employee	$2b$10$YoEvlWPKQKIav41yStSIZuWJpl6BdioKPTZniUMg2udlvPjj6Icfa	talon.villanueva
894	Jaxxon Duarte	902	5	f	employee	$2b$10$yGO.VBDGwVXhB1EJybd6peVhfLsKx0dnfJB8MIMEmCdbC7thsjQYW	jaxxon.duarte
896	Keenan Anderson	902	5	f	employee	$2b$10$fM12ifFuQTd9knLbHQSWfO5oAqPPUdrzheuCxw8posdYNjCwGFJxS	keenan.anderson
898	Ryder O’Donnell	902	5	f	employee	$2b$10$SAh4F9.vR1xinV/SbMkF2eHQKEzFMBULuRegehGdblT6i6XaR/rMi	ryder.o’donnell
901	Treasure Barker	902	5	f	employee	$2b$10$utBwTFyLPSarJ9tnLCtJEuFFwYXDFQnbIwB/rrx/vSJQ6tJ6jgps.	treasure.barker
903	Makenzie Randolph	909	5	f	employee	$2b$10$NMjqSdSqbj1khI7itQ/p.OICJw6GPEIeJvQwDNu03Uc8Lt80m3.8C	makenzie.randolph
906	Emir Flowers	909	5	f	employee	$2b$10$VACLWW9uWwiFfuDMTg2nse.inWzkTqCsubJE8Rpz2uCgvBPsywqWS	emir.flowers
908	Emiliano Burns	909	5	f	employee	$2b$10$12JttZRMhUkRlIw6v64b2OTcmEcnZFWZ6PdsEkdMgS8vhVGsYZbTO	emiliano.burns
910	Pedro Pugh	916	5	f	employee	$2b$10$EfF1SSjZ6G6JoA.7rR0Dz.DuHF2DaYfcuOXQcAgvBR5sRWEsz1.w.	pedro.pugh
912	Frederick Flynn	916	5	f	employee	$2b$10$AKvMOF4lKOhCpMQOgHoAGO2BTOPPCnCcxinGbMJ0vFxoOlOTh7UTW	frederick.flynn
914	Raiden Walls	916	5	f	employee	$2b$10$ebbNCp4SSikDau3hJsLNdOClf5GQwdl5KfOHtQPKGCOnIfEz3i0LO	raiden.walls
916	Davian Woodard	934	5	f	manager	$2b$10$/uYBpMUK2G5Lx4wIrT1Zmumzth9n8n2w7g/Ez98H.EewQU0Dyv3hW	davian.woodard
919	Abigail Fry	923	5	f	employee	$2b$10$Wbpc9ZYpa5qATBab.trAv.61DSo5dGmzDchaeaDcDjuq.WXu6NdMK	abigail.fry
921	Meilani Beltran	923	5	f	employee	$2b$10$jYdNWY0/h4QlKAkcmdw3FO3KLr2amKAYmHYRFya1WLLN0WbCViVky	meilani.beltran
923	Madilynn King	934	5	f	manager	$2b$10$4wW1nMxH46howAL3wJ2RRe0A2PJFGTAF6vW6g35jINt/Eik7Qk3nG	madilynn.king
925	Haven Singleton	934	5	f	employee	$2b$10$Kcs99nLts6PiLNEbvUsCRehOC/w2lduhkmWKk3V71jocAracgZ/hC	haven.singleton
927	Elise Velasquez	934	5	f	employee	$2b$10$1ExbpM119neLKkKh86boUuay4hEijX.KP5M3VZTamocKx.x/FAxZ6	elise.velasquez
930	James Rangel	934	5	f	employee	$2b$10$oilyCvnUkA7qgUOWZTFEg.Sf3M4S8kTJ4w7yOmxD5eix8zZd7FqAi	james.rangel
932	Lochlan Parrish	934	5	f	employee	$2b$10$WVkiv6h4Xv6OTm1dVh5HX.C.FhvaXw.wRW/wV3mGepIumQnMqGEAa	lochlan.parrish
934	Ledger Grant	988	5	f	manager	$2b$10$1Fb.NOHTpljySPhbao.P0ud7bt93dQF8s4HpT2ngRUEAR4gB6ScFu	ledger.grant
937	Natalia Mack	943	6	f	employee	$2b$10$UcXZ7MNSpo9ixPTmfBtHk.D397ix3q7LAIcSTVrkjEUPoge8bic.q	natalia.mack
939	Della Gibbs	943	6	f	employee	$2b$10$C6sVsDG7cWZS5BhCGmGRienmPA4mP46dC90nO4hW8QTyA8pD4cDAe	della.gibbs
942	Jeremiah Knox	943	6	f	employee	$2b$10$WIBTgpbOGT9pIFPIl7z/kuhn2iSdhYoY4jMbe04EtzWm4WAmFW9jG	jeremiah.knox
944	Hector Bernard	948	6	f	employee	$2b$10$wifINgb.D5NcIm/O9cfyqe3.JVnGLkn7y25yFvKDJAQWpMT.1yxoa	hector.bernard
946	Axel Pacheco	948	6	f	employee	$2b$10$EqqCsRysJKMfID4mMmHqo.CQUe4RAcStsJg3lo0ET9J4rf8Jyzy.2	axel.pacheco
727	Miranda Curtis	733	5	f	employee	$2b$10$yFTyAUn2cbId5XZuTp4lSO30p9VhXqOppS/SASbnFpsbZdZrHD3ZO	miranda.curtis
728	Muhammad Singleton	733	5	f	employee	$2b$10$yCD2ZVOGiGK.OMb/R7Q4OuhebyMDtGnKITg3aV4/MF.r1lw5pRbCK	muhammad.singleton
729	Malaysia Bautista	733	5	f	employee	$2b$10$it0WEoXzMYmzWS1AFdkUw.JERcgmGBbVeBTol.4nG6zWypVuoTPv6	malaysia.bautista
730	Raul Dorsey	733	5	f	employee	$2b$10$stIvp3vBelFrmDAM/AlIEOpAXj4zsEZHrijYhlFHDEhcpF3asfikO	raul.dorsey
731	Addyson Shields	733	5	f	employee	$2b$10$JoplYeQ8zTNGY5SURTXKHOSJ3zPK6taiuIdLy3z4bVibxVJIzFJ22	addyson.shields
732	Devon Walsh	733	5	f	employee	$2b$10$UMavVWatudvKrWx1C0tVfe4N11/o1LnjjfFSLcogX//EUbtxLsACa	devon.walsh
733	Leia Adams	934	5	f	manager	$2b$10$1PxCIk9QhHIBe5EQjTwzHeSvLKURAsvpjvfavDmUUojOFCRlmkF.q	leia.adams
734	Hudson Jarvis	744	5	f	employee	$2b$10$qiyrqx7BhdE5P7E2qmqz7exiP01.BcrLSPxx9D4uFd.O2OSKSjaL2	hudson.jarvis
735	Elisabeth Bautista	744	5	f	employee	$2b$10$n6uxWzNfFPscEs0IbyDPgebGRxMxHhV0151BWWZmfOelRQvMcGEZm	elisabeth.bautista
736	Raul Norman	744	5	f	employee	$2b$10$qThbpnS3huAyvLinI.yz1.AY.R8utZ6oSk8hUMsWyA3vJBcvcvbXu	raul.norman
737	Malani Woodard	744	5	f	employee	$2b$10$D7I2i06BuzQad0exXbIueOTT89689SPfAw0ZkD97qTuM.GYd.jx5u	malani.woodard
738	Westley Erickson	744	5	f	employee	$2b$10$sy.66TbOekXU8GvPmDG5a.WcJqVBBGSLm4IEY3Vy1WivtvDVBsRYK	westley.erickson
739	Sabrina Wiley	744	5	f	employee	$2b$10$E1kILUtMUbH73MnTC.usd.c2N66SnEmPI3BKoNXtwGmgRzaq0bzze	sabrina.wiley
740	Mathew Avery	744	5	f	employee	$2b$10$YTqR9g/NgzyvtZlwnYjN.eG6H2Wpr7jVAcE4Ee9Gyy1Y72JjUzFzO	mathew.avery
741	Meghan Juarez	744	5	f	employee	$2b$10$7mny0QDY95N1k3z9L5DIkO4ued2OT3/KHVsevmnGlofQoH4Acm8I.	meghan.juarez
742	Joaquin Lyons	744	5	f	employee	$2b$10$TQ0jKfgqhxjkIEojXWRcguOObWBcevh7ou3SvrmMFzaX/Oj.J1z76	joaquin.lyons
743	Kenzie Henry	744	5	f	employee	$2b$10$dG3/elkwQQB7AhKlRU/pb.Am/HH24lCRaJA40EduUo2hvyUQukWcK	kenzie.henry
744	Carlos Mullen	934	5	f	manager	$2b$10$/3MfIJm4APB9Wy68XmFiqO7fuSjqUEE202My4GFxvLO5x2EzWb/oq	carlos.mullen
745	Shay Ford	753	5	f	employee	$2b$10$Njb2locA8KIaBOpTpZ2qAey.mUsHrxgIKnKOV7oR9u0HHSRauMSGm	shay.ford
746	Luis Avila	753	5	f	employee	$2b$10$9xJTr3CWQZNuW2KxiccNAeGNv3YhVPtdaTJN8TK/FPLP2lKhhhE1u	luis.avila
747	Amiyah Barry	753	5	f	employee	$2b$10$RTmrvEFFQ8d3CYtzyk0p6eCMAFP5eulpoohcddGvFIDkVY9yz7U42	amiyah.barry
748	Emery Good	753	5	f	employee	$2b$10$hptHlMmSwxCNdzwJ8yYjm.pZT7RD4cFMlSv4uG3ApEq1mBFhmm3RC	emery.good
749	Nathalia Moon	753	5	f	employee	$2b$10$/JzJOESNee3zRtxaA0FkKubIIWbWiTGvK7Ne9t8urV27qr5w/i4Ji	nathalia.moon
46	Aryan Rowland	48	1	f	employee	$2b$10$nv043JosOi9cLi120c0EzOUcPoRit5dkOSHfy45t2umbMta8Q1LbS	aryan.rowland
237	Melanie Coleman	240	3	f	employee	$2b$10$I9ABJH4cQ1s.ZCqvypA1POWo2wQ0pXw8j1uRxF1lmOkoHhAilDGOS	melanie.coleman
335	Mira Lim	338	3	f	employee	$2b$10$F6cCdcF7Aqv6fYdfxlmE8.rZ7497kW2UXVAUK0xUCyhUYm7aQ5pji	mira.lim
434	Kayson Swanson	441	4	f	employee	$2b$10$lDpspHptGNfUhdx4f7FRIe3VbRam/Z9VimHgu5OpTyTVKQ1N3wcGa	kayson.swanson
533	Juniper Garrison	541	4	f	employee	$2b$10$3snRo5Pw7HxPXDwUDz9CMuMJ9ZBTsXDAXLqbJz9LvC0fOtJnJvOym	juniper.garrison
822	Ahmad Kennedy	831	5	f	employee	$2b$10$PJLXmqFby7CAvEYo8YOUS.ge9tADb1.srkO/q1g09.Sf9laHgq8ja	ahmad.kennedy
38	Dangelo Sawyer	39	1	f	employee	$2b$10$Amxj.xsmYicP3X4EfjOmKeyHIvgQC09xVl3ctyOXFdeJJRLcJLdG6	dangelo.sawyer
98	Gerardo Mayer	110	1	f	employee	$2b$10$QCBOlCf8YoqYWs7GvZIHxuQph1xbundg3rcquJfPWZkbG8jwiyoDG	gerardo.mayer
111	Lacey Lee	117	2	f	employee	$2b$10$yFuq2WiJv1kFMXdXWdQr3emhxFBAX/8E5p2eXtX4j29nfVINh4cgO	lacey.lee
120	Jair Schaefer	123	2	f	employee	$2b$10$slasZePk334lgdlthgHBJ.jnqM4/PfDY2zXhH4Pj5EvJzz1S1yCM2	jair.schaefer
200	Dustin Jordan	201	3	f	employee	$2b$10$2ms5es.teF8zG2W1eqkRY.CCBj5tRmLP2YdRIxOGg8wrNcQB/DN4G	dustin.jordan
233	Willow Romero	391	3	f	manager	$2b$10$KWxTmvu7Bc/xMQBaZsyYT.cwdhQb9jU9v0CizQ6Y1euKaamcLQnBO	willow.romero
256	Marcelo Tucker	260	3	f	employee	$2b$10$u6XcFYoFbu.IVsvSMqepxe7v.EqDTMsGETYSqHYqku186AsqJHUaC	marcelo.tucker
340	Javier Austin	347	3	f	employee	$2b$10$w8/mQCy7NWh1cgT0xpj/zuUBCfBXd5cmElh92tH0DePhpgR/UOt7.	javier.austin
353	Sabrina Baldwin	371	3	f	employee	$2b$10$YrdF6I34JkA9UxMHuY9sDeEXjN469rxccX3zbqm9mTE.mEHSTVlqG	sabrina.baldwin
421	Ila Fowler	423	4	f	employee	$2b$10$k9W1ziNEexyI82TqifJScuw7cGvFhXoylKAzjsTzxa7ov6xTSppPq	ila.fowler
474	Cain Dennis	712	4	f	manager	$2b$10$Ub5GMwFmsQZZEH0iQY1OPu3QkXpW9lUQ7wW7J16k59O/8jY.Ew77S	cain.dennis
498	Israel Becker	501	4	f	employee	$2b$10$qS2D1H.v.4STTikOn/e7S.2UEmHB6QnpqwperVBmOrOHju716kFdK	israel.becker
576	Andrew Graham	577	4	f	employee	$2b$10$OuEvIfcmZdjnI63i/7gBo.DVW7ikgsP2CXnIVThL8qyoE3xnZTzri	andrew.graham
597	Serena Barajas	603	4	f	employee	$2b$10$qWy7tUOCK4HEjR8xgxOTqO83DiM9FFfclAscX71ZRxIlQGt/ZnuFi	serena.barajas
608	Maximo Zimmerman	610	4	f	employee	$2b$10$79xa8/x876RNEDsY1maJgehdvf5sU5PYjCMM7SfTtjG74jOXDbiaK	maximo.zimmerman
693	Marceline Ellison	694	4	f	employee	$2b$10$hMsocLXBCa/elKhL/bF2muHBQYSF3w3uKLo7vfGw.JEQalM0uoaTi	marceline.ellison
720	Jameson Richmond	726	5	f	employee	$2b$10$0jqSq13WxCBC8EqobZ00wey6IlwzTqFKqeNMEUO7tRu3ytmw97SNu	jameson.richmond
763	Addisyn Mercado	777	5	f	employee	$2b$10$sxeoosbEqFGc8DzKUuxLtuPy2Xge28C2ufBklFHUzwt9l5UFk1.BW	addisyn.mercado
830	Amos Yu	831	5	f	employee	$2b$10$a8OP8RPbTq97lhQxWBqpnO5vvAThzjZJfOSLTVONEmZYrXgNhGJ56	amos.yu
726	Cooper Stokes	934	5	f	manager	$2b$10$QwOMSF2aDGZ2BEZaa9CLGuxI3QrFQBZMIyeZTptmvCR9XvY5Qla6e	cooper.stokes
851	Sienna Cisneros	864	5	f	employee	$2b$10$7fzKnDWl5Ll5DYAax6DxM.omeTRCCgMN0DGZ3dG3rqPp2vjLYwsuq	sienna.cisneros
825	Keyla Johnson	831	5	f	employee	$2b$10$6hjOVg3hqjtoWqXvyJxDkefIYMENxcnpO9M4d7MpjmrElBrs73tm6	keyla.johnson
826	Noah Nolan	831	5	f	employee	$2b$10$SVbL8vAT2SeKi3Y9f.UliegZ9aNPLdBHOYBghJdN2crehZm3hxJCO	noah.nolan
828	Lochlan Arnold	831	5	f	employee	$2b$10$lYGsvoKxWz0ysCasRKOJLuOd/CnPmEcIUziqAbP0c76.LNc3c8ZXq	lochlan.arnold
831	Navy Arroyo	934	5	f	manager	$2b$10$S1sapOdfaUqlZsnEJGS.HebvOtTVVVHUp6/yi4/sHq/zdmNt/XLl2	navy.arroyo
833	Elliott Jaramillo	840	5	f	employee	$2b$10$zn0AyN8EV/RF8EMKq6HAI.DlHtoq6.GSiiWeVfQylDVl77GusN6/a	elliott.jaramillo
834	Riggs Goodwin	840	5	f	employee	$2b$10$6pgNcwz/egV0MsDRTDVyeOqrAEiyAuu95AFtgv8VH1guvOtHQCiCy	riggs.goodwin
836	London Terrell	840	5	f	employee	$2b$10$XFhn31bF3cBGrRSOdYL9MObHxDeUXR9WRzAnOQ9PgGiJkkFs.HVem	london.terrell
838	Mateo Griffith	840	5	f	employee	$2b$10$xeHxGLZIRXnzYxnqDALTgek1TNCu4DSIHUA3QQ8ADAkxr7gEafNIO	mateo.griffith
840	Jack Curtis	934	5	f	manager	$2b$10$H7oM9i5jnjQcuQDfcxKnI.vMjpVkQdfcGJxz6KyXw5uRwh1oEjZRm	jack.curtis
842	Johan Buckley	845	5	f	employee	$2b$10$dh5z4HkPM/bjhRdku8Yj6.rDiLcCZRSeAOrOWtL6fPlbUe9hjhWbq	johan.buckley
844	Alistair Quintana	845	5	f	employee	$2b$10$BIPcumU4YN/d.s0MS5Z0uuqqsalEVwberB6k6pX9WmjSoIPTZ/B36	alistair.quintana
845	Kenia Galvan	934	5	f	manager	$2b$10$DmNt2KWkdiu.d6YgcBcLo.WWXJPvI4Vrr1EoqsvD6wV0088QfWI.e	kenia.galvan
847	Layla Schmidt	864	5	f	employee	$2b$10$hNQEKl7OWIqGg/YPTFDzw.iuvWqTM9LtDXDzWY1yEhAjoAuXG3TC2	layla.schmidt
752	Nikolai Rowe	753	5	f	employee	$2b$10$ON2.PWoWhb7mN7jAD24LHuOnuD4PyaGKn9o8dJBiLwfoIAzQoX2x.	nikolai.rowe
823	Brianna Ali	831	5	f	employee	$2b$10$rtx/ixnHxkqPJJToTw9oWOTiib7nnPr.v0fRo2zAWZfZhnanFuweG	brianna.ali
753	Matilda Cantrell	934	5	f	manager	$2b$10$Q5137sqC16M1ftu6eqMz1.lv7imhpEVehToIPH/UjDYj0TmcBsNaK	matilda.cantrell
755	Annalise Lu	758	5	f	employee	$2b$10$HBwkXdL7SFfzJdpg8kkXfedGlikMUNyo2f0D2apXBO.qq0n6ZafoC	annalise.lu
757	Cecilia Sims	758	5	f	employee	$2b$10$kf4UsN0JPOJ01IXZrjlkjO6jEBPwb58d6FSnuwNR.//qeeu328162	cecilia.sims
758	Brian Lu	934	5	f	manager	$2b$10$PvbheNx.NuH82EG1lhYGDOFmwYOJy9ZLEtnYwiRWpKNMuhrxi41ia	brian.lu
760	Grey Ellison	777	5	f	employee	$2b$10$zHMZl5dIsUBS.gL8/QiU0OK04iBICXxuEr1Nyn2NMiJMJTENNEvL6	grey.ellison
762	Elias Duffy	777	5	f	employee	$2b$10$HKTHvQmzABnE1Wnf.H1cz..l4Ch1UEgumFJgfbTedZ22eRBtYRQ3O	elias.duffy
764	Abram Briggs	777	5	f	employee	$2b$10$hu1Ib7qZxLx/ty00v0sgoOsUCKr.V0wA7FNbgbfjvWZL7YnI2BhSi	abram.briggs
766	Stephen Alfaro	777	5	f	employee	$2b$10$1snfvhepYfG2N/9iKaHhZeOUkI.mE8aRo1kOiea43wPzAKkaUoZSi	stephen.alfaro
768	Mylo Valdez	777	5	f	employee	$2b$10$C6VA/ttI7pwBMSKiQS8USuvyrdTPUFmudJcoqlIA6ecc3g5L5xjFu	mylo.valdez
769	Diana Reyes	777	5	f	employee	$2b$10$aWoyS/MENT2YFpZzjJ5v5O13BFwIc9njZU2x1PlKwjn.Q.r405Kyq	diana.reyes
771	Ada Hicks	777	5	f	employee	$2b$10$bc0pb1bHFmu0TQyBXh0aU.XlVGZtFBWst.JvbSdIuW0YwEiOFVOmS	ada.hicks
773	Scarlett Contreras	777	5	f	employee	$2b$10$BT0zFfOkzDiNnubqpnBOaOj0OaiTYP8q..BajikZeLT38d.M33Zfe	scarlett.contreras
775	Cameron Rich	777	5	f	employee	$2b$10$1qDElGBdnBi7qGu2.T.nmOg/YZV9Hh/da4IZpZDXlPSTljW4w/ZBK	cameron.rich
777	Kate McCarthy	934	5	f	manager	$2b$10$COd8YiewOGtFCvsp34dtlOHALfny9GrVVkXijzpFuwQzPu3ycIf3a	kate.mccarthy
779	Juniper Houston	786	5	f	employee	$2b$10$SzyDvicl.8UPZylJocz6hOq4.404812ZES/8S4gBMm2RGvbPHQWTm	juniper.houston
780	Sylas Lugo	786	5	f	employee	$2b$10$lboPmPC./5kAvGkuKEIPjuVQUdlatM9O1whIsoIhVDVUHhZip5Iaa	sylas.lugo
782	Ramon Sawyer	786	5	f	employee	$2b$10$0/GdkZvzAE0HxPANd76eJeQL2XHqpOWun28XxsPmi5nbbvZRI/dRW	ramon.sawyer
784	Joel Riley	786	5	f	employee	$2b$10$4ZZp.XTLCs.sVGRQ85qmteFPIDIvKiMJD2HCM5uIXGHjBsqzOVZUy	joel.riley
786	Lane Meyer	934	5	f	manager	$2b$10$n0vs73oZZIJvP7oKfXjHy.21bXXKULGT5elk8nZ3GInxU8vsdsDAa	lane.meyer
788	Frederick Tran	789	5	f	employee	$2b$10$wNrhO6S3NcQ/JVCyFZ3.zODDKwC9ygXyH9BGP0Gj2pwFLoJ5m51nW	frederick.tran
790	Callum Reilly	797	5	f	employee	$2b$10$1miBg4GnhMb1b1C6rU8RkOib64BQLEHFLMSFlMzItunb/RHdXSgba	callum.reilly
792	Jase Thomas	797	5	f	employee	$2b$10$eUdposNRduEBiRlN3ZW4meBG3v0D9quHkvl9Q66/HHsIMlEBl/iqC	jase.thomas
794	Kobe Massey	797	5	f	employee	$2b$10$J2VrGARx.A1BKIW5Hxhwmuwl5TDDF4nbpVWj9i9otPcfCFmhjvPBW	kobe.massey
796	Davis Lawson	797	5	f	employee	$2b$10$1HdEbdRuDsGAexiVKkBWRezxSd/ncAjvT0DTs5TLf8I7FM55.mZd.	davis.lawson
797	Phoebe Macias	934	5	f	manager	$2b$10$b6sjtw4Gyt4r9UNKKGsUderB0FR4ztoEGkqJPspq7YmBpX8XnfCX6	phoebe.macias
799	River Marshall	815	5	f	employee	$2b$10$PJRpxnQVLvZFEmqiGFW9S.HwrqWu8aJtPfEDQ8Xo27Dv9JjuixN.2	river.marshall
801	Viviana Bautista	815	5	f	employee	$2b$10$UvGqBlgoDgjDTeXwZUOEtOfBFF7hl4N6NNSmog1wfxFeBxZKy2hIq	viviana.bautista
802	Raul Sloan	815	5	f	employee	$2b$10$ZfiL7Rb9jkSpwjrNDLxoG.CAepuNuq0MJzqT8PREd/gzA/Hk.sfJK	raul.sloan
804	Jaxen Riley	815	5	f	employee	$2b$10$5/QRRP7Xyf8wr6wk9asK1exja29x/N3sIQt/LbKGMrmJwq/764.Ca	jaxen.riley
806	Emory Craig	815	5	f	employee	$2b$10$tHmNBgG7lUQOCixGoxSRTeRv3f/Nn7lzuVig0pH/K.9sPzjnu2vuy	emory.craig
808	Atticus Brandt	815	5	f	employee	$2b$10$zVs/1necE.2vnnWK0RTOw.bKRo7gGXjm99cJ6jfnGlIhRq7D92Yku	atticus.brandt
810	Sutton Francis	815	5	f	employee	$2b$10$MFuOVBg0MNVCisigVlWEPOxdTgKzHLh6nA6qnVTFFNryQmehh6hse	sutton.francis
812	Bear Keith	815	5	f	employee	$2b$10$t3FUp1fhWyNd6/W1KW6FC.F1eg3Aa5miC/1KVwPK2Wka.bZvRV1l2	bear.keith
814	Murphy Macdonald	815	5	f	employee	$2b$10$5EevOlvxtl9I5B19djWEo.Px3HtUNaLYG4DfvDKb.ioTIOEeXrfsC	murphy.macdonald
815	Rosalia Sanchez	934	5	f	manager	$2b$10$3RGLMQ5DMB2.sHPGFWtEtuuXuFh1FY5.TfQfBEub9gShKU6R0nsIG	rosalia.sanchez
817	Clarissa Clay	820	5	f	employee	$2b$10$s./EFV1kNPshaK3946MOXe4jbgaum.wL1nnbfn/8j6zUVC91Dcygm	clarissa.clay
819	Genevieve Morton	820	5	f	employee	$2b$10$SUD0NzGuU0kGJA5MZKbp3eNC.K1R/gwG.5gb5WP7ue9JVYDSxdJFK	genevieve.morton
821	Teresa Combs	831	5	f	employee	$2b$10$lFT4XY2mqO4ViqfPO7YtIOxitnvLWoQz.zK6IyBTDZs8ldOD98RTi	teresa.combs
853	Myla McLaughlin	864	5	f	employee	$2b$10$NCCZoQQDz8WtyI9FmbvGleCZRb4JMJnd3wLhHC4K6AFmA01cU3cO6	myla.mclaughlin
855	Lucille Farrell	864	5	f	employee	$2b$10$GVJF8Bh9in5Y59OzgC8bBONM7xlOwTm9qXREQ9fNzkuzX7RsVkPxy	lucille.farrell
856	Ty Brady	864	5	f	employee	$2b$10$/KZNuL/ScYEMiIJGE6SsbetTOikvGyDfIH6gMqzjIW/6rBmXCKBpi	ty.brady
858	Sylas Berry	864	5	f	employee	$2b$10$49XQsCUFlCp6BQz/jIwOxuOcZccOL1EOWAuN/csYB.8Ks81/N5j9.	sylas.berry
860	Eric Schneider	864	5	f	employee	$2b$10$T1mKk4WQU0jhEIRJghkBse.dMlk1N/JWamgG3RDwb1Wfs5Fe4x5jS	eric.schneider
862	Gianni Williamson	864	5	f	employee	$2b$10$ZextEJHfA9V9xJZJzlS/cOmF6FXAQIVhhT5cecaAJGAIXoTqoOI8u	gianni.williamson
864	Victor Luna	934	5	f	manager	$2b$10$tJoO3s49QeAGNOnBWQy4ReiMbY8Ic0PceaAaV/8TTTNC7LoUE9Rpy	victor.luna
865	Journey Ball	873	5	f	employee	$2b$10$Q2I0coaf2mnsPjA6DULVkucLxfyMvWngE6udxW.jnMzbDhNUtZx16	journey.ball
867	Madison Austin	873	5	f	employee	$2b$10$mZMsKR4TdgQA2wg30RmOoO.8ek0h4OgK9kQX/yj9podENCk7Aa/l2	madison.austin
869	Laylah Young	873	5	f	employee	$2b$10$RqvCLUd7hyztR3aJW.NyP.qNH./hWgcMeSXfeGNqoocuCbcLB1IZ2	laylah.young
871	Jemma Maddox	873	5	f	employee	$2b$10$k7KiWarXe8jTaT9hAGX4x.2l4PJgqp59g32nxHlsnSTe0oKbJSzq.	jemma.maddox
873	Khaleesi Merritt	934	5	f	manager	$2b$10$zHEJsyGdnVNEAFPbKVaB8.upqRIzxn2Onj3qY2JheSyZJfOU7853O	khaleesi.merritt
874	Colten Meadows	876	5	f	employee	$2b$10$TwV1u.ZzK1wN2.9pYA8AiuC.sXTU9bsy6loo0MWHoNJhIUCRxDU9G	colten.meadows
876	Lachlan Ramsey	934	5	f	manager	$2b$10$AbbjxGWhriCTQ17WqM.ax.d0QcVxLZWIA2TKv1ypgnPzhVOfkF7fu	lachlan.ramsey
878	Blaine Fuller	884	5	f	employee	$2b$10$qD2GlpWAwkye0T1g118MjO/DGem.YOHpRLGW92rDMopDFMRr7YGpy	blaine.fuller
880	Otis Schaefer	884	5	f	employee	$2b$10$kFotNvnxL1bIGMDxknenD.ZcW0q730lDEoE1hpIzqTn8ipfFylcJG	otis.schaefer
882	Fabian Lang	884	5	f	employee	$2b$10$f8mloG98CNDvxk1kNluRB.2SoFBfhybhYyHQ91jH8z8UsKdkwHism	fabian.lang
884	Gary Garrison	934	5	f	manager	$2b$10$QgY1b2xyJoxqQIpnoYMStukHKtWhIX8VPU4xP6MDcqPy2m4s.5JOu	gary.garrison
886	Damien Harding	902	5	f	employee	$2b$10$dDQEdDb2o1yJdnU3JLXdOucycJPBi6L/G5fj5BUVbvsKcbp.Voy7G	damien.harding
888	Dario Lowe	902	5	f	employee	$2b$10$ItF4KNelmbrQAP3//SvEBe9nSlMyqLVMr9iDzA7tUZqpQQjQ9zXT.	dario.lowe
890	Blaze Hobbs	902	5	f	employee	$2b$10$K7n8qcDv8/AmJb.T8ZVKWeu66nyC2mcqcNO0F4l6ASvrDsvTFqevG	blaze.hobbs
891	Lacey Gaines	902	5	f	employee	$2b$10$yS26/NyJ7APuFZPO4yNfH.Kba7uOSSKBb5BX8pSLI4usmhIv2F9xO	lacey.gaines
893	Monroe Lowery	902	5	f	employee	$2b$10$czVLDGvT4YvYpkXANxHj6.QdYIrUJbgjlOH2r6ZekSHpHK2NCqn4.	monroe.lowery
895	Kynlee Branch	902	5	f	employee	$2b$10$vQxRATcZ3DvOP90sTYHCougVPNmqkYJplnOUSCtexWM8ya9uy/JV2	kynlee.branch
897	Ella Butler	902	5	f	employee	$2b$10$zJQn1Hxw47kDkj8ILzlF/OAbGGQca0vEapag4uArk8AvltAGcYmg2	ella.butler
899	Bellamy Reyes	902	5	f	employee	$2b$10$agwPI5qaJX19.KJTWhjtvemzEFtACnv8vX8eOD7q0ZlGPA3g3FVNy	bellamy.reyes
900	Eli O’Neal	902	5	f	employee	$2b$10$MtPC.FeytvQN7F9CLnoV5.M.gD4Xz315A6N/4SaT/vDm7atMfWFla	eli.o’neal
902	Kade Shelton	934	5	f	manager	$2b$10$vDQcXX.PFibgKf1h1Qdg.ObkRdueYrYNSbCNv5DREsm2pbKUXH1Kq	kade.shelton
904	Eugene Cummings	909	5	f	employee	$2b$10$6SS.qAV2fj.Im1pihIwtiOwaPhJgB0u591zSrnWYiEsHNGuOINM82	eugene.cummings
905	Nylah Sosa	909	5	f	employee	$2b$10$JfHghs2PsyzsQJHf6D48NutwmK5diTEBGtYEZAsJ12NlLsMyp2Ioy	nylah.sosa
907	Ariya Robertson	909	5	f	employee	$2b$10$faKSXPKqZgbINRiZXhWV9.w1SdsZOpTeMc/CAhJxhGT0Qml3j5iqO	ariya.robertson
909	Emerson Liu	934	5	f	manager	$2b$10$2dScnG7o7jsFihjLMrG8uu9jcsUFRPqoeWSwIJEIsffpAswfNTrS2	emerson.liu
911	Landry Wise	916	5	f	employee	$2b$10$ye4mHzsV4x0vRj3m1W0.Z.byGMnq8IV8JPssR69DN/Rj9PpXIgcDe	landry.wise
913	Dorothy Cummings	916	5	f	employee	$2b$10$96fuaLmdZRBd3nMGbQ5SAeN/sbIee5HYjBn692Kt7ISGrraCf.B66	dorothy.cummings
915	Lilianna Good	916	5	f	employee	$2b$10$pbji7ki50xc/OFYwirQrs.1l1aVhCvheYIup679AIh6OrMNcjDd/6	lilianna.good
917	Aubrie Adkins	923	5	f	employee	$2b$10$gQ.vW7azceV3I4uV9dxbUOKyAa9VPfPcOYLX.dmykb03OHZynNTuK	aubrie.adkins
918	Kylo Gonzalez	923	5	f	employee	$2b$10$CPuUXvG0AY7L0pr/7ZK4TuhM4VwB.VUQZvFLj887kp../5wsE1tAq	kylo.gonzalez
920	Jacoby Sampson	923	5	f	employee	$2b$10$8PeVA4/EAhS.cB8YojoTN.oN0yDS72AAXvhvdefoWSKoqtH1E1Eym	jacoby.sampson
922	Ricky Ibarra	923	5	f	employee	$2b$10$MP2/O8ngegcMWDRvkK8Jo.tZoJoh8kmtttcoU/5RCH7z5Xg.M1KQu	ricky.ibarra
924	Julian Cortez	934	5	f	employee	$2b$10$NtDkpLZ8AeqJWIFmxWJv2u.jVrkIc/4Y5G8.GCypDw5SSH0.IzJZW	julian.cortez
926	Landyn Duncan	934	5	f	employee	$2b$10$u4dM8vULFvwEW2L4s3VGFOn/1QzTfw61qenIyqgKZtdywI7Iic4kG	landyn.duncan
928	Sullivan Douglas	934	5	f	employee	$2b$10$QQqUECVFynXKiadzINfcCu/n7U6nYI7ENDPHMigPTgmjB68KogN16	sullivan.douglas
929	Aniyah Garcia	934	5	f	employee	$2b$10$0e6WM/dWPWj6RO2vtUwx3.Gg34RNx2VgScJFa8oYaS8V9aOgBQeOW	aniyah.garcia
931	Gloria Walter	934	5	f	employee	$2b$10$RWSt7eg0XoQw.agKyXqb/OGT38sM2Bufy.UHHulGKrPrMtvQwJ4Zy	gloria.walter
933	Tiana Christian	934	5	f	employee	$2b$10$VToKRvIx.E/xBbjihQ7PKOJV/oxxc8K9GLmGZ6UtSUJlqWTK4gqq2	tiana.christian
935	Alaina James	943	6	f	employee	$2b$10$RJ5hV22IzSFTfNgC2sAv5OQ0zv525aGGuXkXo1WcYFEHqn/XchTdu	alaina.james
938	Esteban Crane	943	6	f	employee	$2b$10$jF6Ayq1rFwtdMNd0SwRh/.q/bmxb9.lVdon4Z/2B.dV6.a1QsaJLO	esteban.crane
940	Deacon Baxter	943	6	f	employee	$2b$10$SlHhnoOu7h660xm9iFF1EuPssoaMNv/Sxe1oBMjPvrC38U0LY9/he	deacon.baxter
941	Lara Howard	943	6	f	employee	$2b$10$LRjZgtV.eXBnq9uF6ZY0JOEpS.1m2XLkHWER1Us8Urt2LdNg5JXda	lara.howard
943	Kallie Hail	987	6	f	manager	$2b$10$sJZKrANuS0SubWHfVGjNXuQw1Kar88P33ucH9T4Tev7avmC.UfIOe	kallie.hail
945	Barbara Bailey	948	6	f	employee	$2b$10$H8Mldk7SRa.zZhl78r0s3ug.e7d0pbaudm9g945ZmjAtlnNq8Tj2G	barbara.bailey
947	Paris Ryan	948	6	f	employee	$2b$10$JezsQ8i29Qv6iQYbtX99SOWDkUv4Z0S/Nirhd1mgmB2zeYz7/AEQm	paris.ryan
951	Jaylin Lucero	967	6	f	employee	$2b$10$BNjDevOyGbWXfEW9Tj5ySOJVLDAcy1U8gghLUG5kG6/aYuvn8VGe.	jaylin.lucero
952	Felipe Walton	967	6	f	employee	$2b$10$B8L8AMLU9/RR0LqsNurl9e.47/fXEycns72DUTLlobyvFz8ShNEja	felipe.walton
953	Scarlet Sanford	967	6	f	employee	$2b$10$.oAKmVd7m3PxBy0y5OmC3.a.synTbcIaqH4/jNKKD4pIopMQGl8AK	scarlet.sanford
960	Aziel Dean	967	6	f	employee	$2b$10$q4gJp7HKoFJutWZZZ3YXoetr5s9ccPUp6gscBRsQ4KMUY0IX.ccaS	aziel.dean
961	Julianna Owens	967	6	f	employee	$2b$10$fK3SBL9hBCrxzwzorOGWXe.YxDNJpXMPl7pC1vJ8oDTg4dUqf1AkK	julianna.owens
962	Adriel Romero	967	6	f	employee	$2b$10$ZrZjosc8y1khVOhbWuL0ZuUUuuPtH/GLIxNXZogy4MavxiBm9iqXu	adriel.romero
963	Eliza Watson	967	6	f	employee	$2b$10$FfVzihLAxrfKsn2OuCN4ueLOpy.uvAPdymfZf3a7JWqrZm8sBjHcy	eliza.watson
964	Greyson Hernandez	967	6	f	employee	$2b$10$4nlLYV0lmi5E0cAZhI6qXOGPjd/RPIWEqlgUj4/3YLWgiFe5aNQ2m	greyson.hernandez
965	Camila Gutierrez	967	6	f	employee	$2b$10$1Ws09R09A8t39IX/ManrAutM0UzozGahXSfS5tbbvEVXyp.qgGwxO	camila.gutierrez
966	Luca Escobar	967	6	f	employee	$2b$10$/hbX1n3I3QyZUaBkP59tHeuVLbnOMTKZPMUqvmcnwz8P.WQ7qSQz6	luca.escobar
967	Erin Enriquez	987	6	f	manager	$2b$10$8.NSedHTGnF2tivwOr27MuFT8pKjs62vxAJnuZzUoLh6UJVtsDk8y	erin.enriquez
968	Elisha Ali	976	6	f	employee	$2b$10$uMIuqReNls.9DbW4J041cu1pmFpTa8eqlQ.ZAtgZWgnvPQCMeWjcW	elisha.ali
969	Zelda Conrad	976	6	f	employee	$2b$10$eTbyY7xpeXxTZpwfT8Vw7edm1Wee7wfdHQK2c2F/PG8f5PEzXiyVy	zelda.conrad
970	Dilan Fitzgerald	976	6	f	employee	$2b$10$Fw4yA0e5hO0mfLUmlD8bWO6VaJdtef83I/xIIZQh/lIBd5Fk2.om.	dilan.fitzgerald
971	Marlee Carrillo	976	6	f	employee	$2b$10$xF8QTaDeCmaUh8RRDgnHkeBHFtfaffKxy3qN1JKCQDbxxo7Vug/N.	marlee.carrillo
972	Wade Roman	976	6	f	employee	$2b$10$UyC3tQSHLzQGUXVvOESuue6kje1O5m0RXTXNjENFwJn33z1kO2peu	wade.roman
973	Astrid Pruitt	976	6	f	employee	$2b$10$q2.CvfUiYHNU1MUEKsviHuJoUy85yGyYQwdSbXwt.aCqTXmQBiq16	astrid.pruitt
974	Gatlin Daniels	976	6	f	employee	$2b$10$ofO1jljfSmxNxRybDjA1uOBZNbcngYPU6vk9g.4.Q1L3mj8hs4aKa	gatlin.daniels
975	Ember Lowe	976	6	f	employee	$2b$10$/JOsN1T0TJ5kqS78NVBNfOfmUR0U5kM82V7v8E.FroIdMqpGlSBRW	ember.lowe
976	Julius Brandt	987	6	f	manager	$2b$10$p48ei5G57CsRTtPhse61XOWL2GHj7H./eU.bvtnX6vkOrRMYKma0.	julius.brandt
977	Loretta Adkins	979	6	f	employee	$2b$10$QlPzo7tBLDhUdsXS10tbHeWRBA0cySRlasjMYSWBGQKTEBaP0Fkoa	loretta.adkins
978	Kylo Marks	979	6	f	employee	$2b$10$.wZ.Nv5zdser7rhsLE5EC.kQiNC9TwL3CvWoPFmsCadMkPB.A4gYK	kylo.marks
979	Monica Sullivan	987	6	t	admin	$2b$10$QTzJu0Gl6msvU79iPucRne5yiYvTXe7tvFMMxaJSctHs6oY3YCyPS	monica.sullivan
980	Evan Castillo	987	6	t	admin	$2b$10$/pPrHxGhCqkeudzEFiTgbOrz6jhjguS3SI3Y0vnMS/0oH0HuaP6OO	evan.castillo
981	Eva McPherson	987	6	t	admin	$2b$10$puU.zbQ.dQLEgwLWQLgKDuiYd88eTyP4w0EEcrj0LvOS7jvS0eqYi	eva.mcpherson
982	Foster Avila	987	6	t	admin	$2b$10$rUNEKrQVk3lNB5NgOAkpGeWjkmMZqSeov.g67nN1R.R7sFZfnGGQq	foster.avila
983	Amiyah Wu	987	6	t	admin	$2b$10$EEBzJpwiUgwOk9M77xOJrutEUwi6YNEAtwBntRB82nMLIdOIMHIRW	amiyah.wu
984	Kyson Salinas	987	6	t	admin	$2b$10$wFfWwcsDhdX3uC9PXx6rKOq2hyrI64JTelwgGdFhRK3Mx2uXAnHt.	kyson.salinas
985	Royalty Melton	987	6	f	employee	$2b$10$YICQ1WhWvsAJqVsRfQuySeXLpaq80EBgrQQ5I8F24D2unOsumABh.	royalty.melton
986	Lennon Harvey	987	6	f	employee	$2b$10$Pei.UWPmmJ5sbdlteskbeOJHvqMq.VY0LU..4AVx.f2k3AsQk8.Ve	lennon.harvey
988	Crosby Reeves	\N	7	f	manager	$2b$10$WMoDjrhlxnyI2IvGo/JFe.qk2MvvCfmlqqCjjCaylqlCw7Ox1tsUe	crosby.reeves
948	Timothy Hanna	987	6	f	manager	$2b$10$xNehgWCc8nLApOiygHlt/ODCGBlbOyamLykm0DtcixHFAejUSwTiG	timothy.hanna
949	Cynthia Lane	967	6	f	employee	$2b$10$AFnNyR1pUTYa74mn1zesYuIWfaRLRC6F.8zO6dQ37R3p0D0BVuXtK	cynthia.lane
950	Matias Bentley	967	6	f	employee	$2b$10$eUGjx92LAQbVMrdT0xE3zuMjaRVuWMzONqpClvQc8Wun1iqCtDTai	matias.bentley
954	Truett Fitzgerald	967	6	f	employee	$2b$10$/5v.5fgRVo3i6TDigQkqy.ep/ESwdAZLL1iNp04OlyhstgQUtqOr2	truett.fitzgerald
955	Marlee Garrett	967	6	f	employee	$2b$10$AE9tUrpyBO0gqhvgFybKMOz/f90SQg9mP2pY8SMTmn7/xdzQUqT5y	marlee.garrett
956	Kairo Bass	967	6	f	employee	$2b$10$2faVfQ.EwYvpC4tNPWwrBOGGeEq8uHR2JydPNjiO2spOTErRsDE5.	kairo.bass
957	Zahra Davila	967	6	f	employee	$2b$10$TP04DnOpBbIy7wtB1LkA7./2o/4HN/1myc2a3EHFdEk8fN93RJYUO	zahra.davila
958	Grey Mays	967	6	f	employee	$2b$10$pV/tLmFiTu/dxwbgLbPjCeDqwOTozBwrP6pqIQe2jYVZ1abHhQIIa	grey.mays
959	Denisse Norman	967	6	f	employee	$2b$10$Tj7aju6YRPtRKTcxpr7yx.oEFGZgurSeu7/e0wIw6IqsasSIAgHSu	denisse.norman
987	Nicole McLean	988	6	t	admin	$2b$10$xmtOypkz.OC3TPfnNAof/OujEdyvJXEZr2NU3cKQMz/w5dj6zx9Dm	nicole.mclean
\.


--
-- TOC entry 5117 (class 0 OID 16808)
-- Dependencies: 223
-- Data for Name: person_project_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_project_assignment (person_id, project_id, status) FROM stdin;
\.


--
-- TOC entry 5118 (class 0 OID 16814)
-- Dependencies: 224
-- Data for Name: person_skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_skill (person_id, skill_id, status, level, years, frequency, notes, requested_at) FROM stdin;
979	9	Requested	Intermediate	1	Weekly		2025-12-03 05:53:16.808433
979	11	Requested	Intermediate	0	Weekly		2025-12-03 05:53:29.848261
231	9	Requested	Expert	\N	\N	Seeded assignment	\N
581	23	Requested	\N	\N	Monthly	Seeded request	2025-11-26 07:58:27.264874
632	18	Approved	\N	\N	Daily	Seeded request	\N
646	7	Approved	Expert	\N	Monthly	Seeded assignment	\N
341	18	Approved	\N	\N	Rarely	Seeded request	\N
756	25	Approved	Expert	9	\N	Seeded request	\N
116	19	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
223	9	Approved	\N	10	\N	Seeded assignment	\N
776	1	Approved	Advanced	\N	Rarely	Seeded assignment	\N
196	17	Requested	Advanced	10	Daily	Seeded assignment	\N
873	1	Requested	Intermediate	0	\N	Seeded assignment	\N
151	25	Requested	\N	2	Monthly	Seeded assignment	\N
472	22	Approved	Intermediate	2	Monthly	Seeded request	\N
253	25	Approved	\N	10	Rarely	Seeded request	2025-11-26 05:07:27.264874
816	21	Approved	\N	\N	\N	Seeded assignment	2025-11-17 02:48:27.264874
696	8	Approved	\N	2	Monthly	Seeded request	\N
109	21	Requested	Intermediate	\N	Daily	Seeded assignment	2025-11-26 03:56:27.264874
352	13	Requested	\N	4	Daily	Seeded request	\N
409	18	Approved	\N	\N	\N	Seeded assignment	2025-11-04 03:42:27.264874
417	12	Requested	Beginner	3	Rarely	Seeded assignment	2025-11-05 16:12:27.264874
876	20	Approved	\N	6	Rarely	Seeded assignment	\N
901	4	Requested	Beginner	0	\N	Seeded assignment	2025-11-19 00:42:27.264874
884	22	Requested	Beginner	7	Daily	Seeded request	\N
861	21	Approved	\N	\N	\N	Seeded assignment	\N
944	1	Approved	Beginner	6	\N	Seeded request	2025-11-18 14:46:27.264874
331	3	Approved	Advanced	6	\N	Seeded assignment	2025-11-12 13:58:27.264874
142	21	Approved	Intermediate	10	Rarely	Seeded assignment	2025-11-28 10:48:27.264874
683	20	Approved	Intermediate	\N	Daily	Seeded assignment	\N
798	3	Approved	Intermediate	\N	\N	Seeded request	2025-11-09 12:03:27.264874
477	5	Requested	\N	\N	Monthly	Seeded assignment	\N
920	16	Requested	\N	3	\N	Seeded request	\N
782	6	Requested	Expert	4	\N	Seeded request	\N
320	8	Requested	Intermediate	4	Weekly	Seeded request	2025-11-10 21:44:27.264874
545	11	Requested	Advanced	\N	Weekly	Seeded assignment	2025-11-12 07:03:27.264874
359	17	Approved	Intermediate	3	Weekly	Seeded assignment	\N
241	21	Approved	Advanced	\N	Monthly	Seeded request	2025-11-18 12:21:27.264874
51	13	Approved	\N	\N	\N	Seeded assignment	2025-11-18 11:32:27.264874
197	18	Approved	\N	7	Monthly	Seeded request	2025-11-18 21:07:27.264874
339	25	Requested	\N	\N	\N	Seeded request	\N
441	19	Requested	\N	\N	\N	Seeded request	2025-11-04 05:59:27.264874
825	10	Requested	\N	\N	Monthly	Seeded request	2025-11-12 01:14:27.264874
702	18	Requested	Intermediate	\N	Monthly	Seeded assignment	\N
555	10	Requested	Intermediate	2	Monthly	Seeded assignment	\N
716	22	Approved	\N	7	Daily	Seeded assignment	\N
808	3	Approved	Beginner	\N	Daily	Seeded assignment	\N
741	8	Requested	Intermediate	7	Rarely	Seeded request	\N
170	7	Requested	Expert	5	Rarely	Seeded request	2025-11-10 18:34:27.264874
898	24	Approved	Advanced	\N	Rarely	Seeded assignment	\N
527	9	Approved	Intermediate	\N	\N	Seeded request	\N
773	9	Approved	Advanced	\N	Rarely	Seeded request	2025-11-25 12:04:27.264874
157	4	Requested	\N	\N	Weekly	Seeded request	2025-11-15 00:17:27.264874
43	1	Requested	Beginner	\N	Weekly	Seeded assignment	\N
933	9	Approved	\N	\N	Weekly	Seeded request	2025-11-16 16:10:27.264874
37	23	Requested	\N	\N	Monthly	Seeded assignment	2025-11-21 09:36:27.264874
430	13	Approved	\N	\N	Rarely	Seeded assignment	\N
166	22	Approved	Intermediate	\N	\N	Seeded request	2025-11-25 03:17:27.264874
934	13	Approved	Intermediate	2	\N	Seeded assignment	2025-12-02 06:31:27.264874
249	13	Requested	Advanced	\N	\N	Seeded assignment	2025-11-30 16:32:27.264874
919	8	Requested	Expert	5	\N	Seeded assignment	2025-11-18 09:15:27.264874
887	25	Approved	Beginner	3	Monthly	Seeded request	2025-11-30 08:08:27.264874
434	11	Requested	Expert	10	Monthly	Seeded assignment	2025-11-17 12:10:27.264874
659	16	Approved	Advanced	10	Daily	Seeded request	\N
547	6	Approved	Advanced	4	\N	Seeded request	\N
755	7	Approved	Advanced	7	Monthly	Seeded request	\N
706	17	Approved	Advanced	6	Monthly	Seeded assignment	\N
156	13	Requested	Advanced	\N	\N	Seeded request	\N
215	23	Approved	\N	4	\N	Seeded assignment	\N
709	18	Approved	Intermediate	\N	Rarely	Seeded assignment	2025-11-26 02:57:27.264874
133	7	Requested	\N	4	\N	Seeded assignment	\N
354	19	Requested	\N	\N	Rarely	Seeded request	2025-11-15 15:33:27.264874
949	24	Approved	Intermediate	1	Daily	Seeded assignment	\N
455	25	Approved	Beginner	\N	Monthly	Seeded request	\N
616	3	Requested	\N	0	Weekly	Seeded assignment	\N
961	11	Approved	Advanced	\N	\N	Seeded assignment	2025-11-14 12:24:27.264874
511	5	Approved	\N	\N	Weekly	Seeded request	\N
40	8	Approved	\N	\N	\N	Seeded request	2025-11-08 06:06:27.264874
182	8	Approved	\N	9	Rarely	Seeded assignment	2025-11-03 17:22:27.264874
97	11	Requested	Expert	1	Weekly	Seeded request	2025-11-11 11:50:27.264874
209	25	Approved	Intermediate	4	\N	Seeded assignment	\N
277	8	Approved	Expert	0	Monthly	Seeded assignment	2025-11-15 14:12:27.264874
210	16	Approved	Intermediate	4	Monthly	Seeded request	2025-11-25 11:03:27.264874
261	8	Requested	\N	1	\N	Seeded assignment	\N
362	20	Requested	\N	6	\N	Seeded assignment	2025-11-22 02:55:27.264874
937	23	Requested	Intermediate	\N	Daily	Seeded request	2025-11-20 19:19:27.264874
597	1	Approved	Intermediate	\N	Daily	Seeded assignment	2025-11-03 19:31:27.264874
800	6	Approved	\N	\N	Monthly	Seeded request	2025-11-17 05:15:27.264874
169	1	Approved	\N	10	\N	Seeded assignment	\N
421	7	Requested	\N	\N	\N	Seeded assignment	2025-11-12 02:18:27.264874
37	7	Requested	\N	\N	Monthly	Seeded assignment	\N
8	11	Approved	\N	0	\N	Seeded assignment	\N
730	8	Requested	Expert	0	Monthly	Seeded assignment	\N
564	5	Approved	Advanced	1	Rarely	Seeded request	\N
418	13	Requested	Advanced	\N	Weekly	Seeded assignment	2025-11-11 00:50:27.264874
573	3	Approved	\N	7	\N	Seeded request	2025-11-14 11:10:27.264874
784	16	Approved	Advanced	0	Rarely	Seeded assignment	\N
490	4	Requested	Intermediate	1	Monthly	Seeded request	2025-11-25 05:27:27.264874
634	9	Approved	\N	0	\N	Seeded assignment	2025-11-19 03:52:27.264874
259	3	Approved	\N	\N	Rarely	Seeded request	2025-11-15 12:02:27.264874
204	18	Approved	Expert	2	\N	Seeded request	\N
769	5	Approved	Intermediate	10	Daily	Seeded request	\N
67	19	Approved	\N	7	Rarely	Seeded assignment	2025-11-26 05:06:27.264874
89	24	Requested	Intermediate	\N	Daily	Seeded request	\N
118	1	Requested	\N	\N	Monthly	Seeded assignment	2025-11-17 17:53:27.264874
160	24	Requested	Advanced	\N	Monthly	Seeded request	\N
48	18	Approved	Advanced	6	Weekly	Seeded assignment	2025-11-07 23:52:27.264874
230	25	Approved	Advanced	\N	Weekly	Seeded assignment	2025-11-28 03:46:27.264874
553	20	Approved	Advanced	2	\N	Seeded request	\N
516	5	Approved	\N	\N	\N	Seeded assignment	\N
71	21	Approved	Intermediate	\N	Rarely	Seeded assignment	\N
697	20	Approved	\N	\N	Weekly	Seeded request	\N
785	25	Approved	Beginner	7	\N	Seeded request	\N
356	18	Approved	Intermediate	9	\N	Seeded assignment	\N
940	20	Approved	\N	\N	\N	Seeded assignment	2025-11-17 20:04:27.264874
844	19	Approved	\N	2	\N	Seeded assignment	2025-11-08 18:58:27.264874
248	13	Approved	\N	3	\N	Seeded assignment	2025-12-02 21:28:27.264874
579	6	Requested	Advanced	1	\N	Seeded request	\N
688	19	Requested	\N	9	Monthly	Seeded assignment	2025-11-16 21:31:27.264874
881	11	Requested	\N	6	Weekly	Seeded assignment	\N
251	17	Approved	\N	3	Monthly	Seeded request	\N
542	11	Approved	\N	7	Rarely	Seeded assignment	2025-11-11 09:02:27.264874
288	24	Approved	\N	\N	Weekly	Seeded assignment	\N
549	10	Requested	\N	5	Weekly	Seeded request	\N
500	8	Approved	\N	4	Rarely	Seeded assignment	2025-11-18 02:21:27.264874
937	7	Approved	\N	3	Daily	Seeded request	\N
390	12	Requested	\N	2	Weekly	Seeded request	2025-12-01 08:04:27.264874
779	24	Requested	\N	3	\N	Seeded assignment	\N
91	8	Requested	Expert	\N	Monthly	Seeded assignment	\N
944	9	Approved	\N	9	Monthly	Seeded request	\N
421	23	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-27 08:23:27.264874
818	7	Requested	\N	\N	\N	Seeded assignment	\N
82	25	Approved	\N	2	Weekly	Seeded assignment	2025-11-06 06:00:27.264874
313	11	Approved	Advanced	\N	Weekly	Seeded request	2025-11-18 23:57:27.264874
581	7	Approved	\N	3	\N	Seeded assignment	\N
924	9	Approved	Expert	\N	Weekly	Seeded assignment	\N
617	21	Approved	\N	2	Weekly	Seeded assignment	\N
664	10	Requested	Expert	3	\N	Seeded assignment	2025-11-05 14:49:27.264874
491	22	Approved	Beginner	\N	\N	Seeded request	2025-11-19 13:42:27.264874
870	13	Approved	Advanced	\N	Monthly	Seeded request	2025-11-20 20:42:27.264874
656	7	Requested	\N	3	\N	Seeded assignment	2025-11-12 12:16:27.264874
689	6	Approved	Expert	1	\N	Seeded assignment	\N
453	4	Approved	\N	1	Daily	Seeded request	\N
365	8	Approved	Intermediate	8	Weekly	Seeded request	\N
683	12	Approved	Intermediate	5	Rarely	Seeded assignment	\N
971	18	Approved	Beginner	1	Weekly	Seeded request	\N
519	7	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-13 23:38:27.264874
554	24	Requested	Beginner	\N	\N	Seeded assignment	2025-11-03 21:54:27.264874
240	16	Approved	Beginner	10	Weekly	Seeded assignment	\N
318	12	Approved	Expert	\N	Daily	Seeded assignment	2025-11-19 04:21:27.264874
30	11	Approved	Beginner	\N	Daily	Seeded assignment	2025-11-13 18:40:27.264874
169	9	Approved	\N	4	Weekly	Seeded request	2025-11-21 05:49:27.264874
711	22	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-25 20:38:27.264874
470	12	Requested	\N	\N	Rarely	Seeded assignment	2025-11-22 13:34:27.264874
87	9	Approved	\N	\N	\N	Seeded assignment	2025-11-05 20:48:27.264874
88	4	Approved	Advanced	8	Monthly	Seeded assignment	\N
567	19	Approved	\N	3	\N	Seeded request	\N
481	5	Approved	\N	\N	\N	Seeded assignment	\N
925	16	Requested	Advanced	3	Weekly	Seeded assignment	\N
612	16	Approved	\N	1	Rarely	Seeded assignment	\N
134	5	Approved	\N	\N	Daily	Seeded request	\N
128	23	Requested	\N	9	Rarely	Seeded request	\N
571	18	Approved	\N	3	Rarely	Seeded assignment	\N
658	19	Requested	\N	8	\N	Seeded assignment	\N
762	11	Requested	Advanced	\N	Weekly	Seeded request	2025-11-19 06:03:27.264874
597	9	Requested	Advanced	6	\N	Seeded request	2025-11-20 16:00:27.264874
661	7	Approved	Expert	0	\N	Seeded assignment	\N
628	11	Approved	Expert	\N	Monthly	Seeded request	\N
521	5	Requested	Expert	2	\N	Seeded assignment	2025-11-17 07:16:27.264874
436	22	Approved	\N	8	\N	Seeded assignment	2025-11-25 16:47:27.264874
282	21	Approved	Intermediate	\N	\N	Seeded assignment	\N
395	19	Requested	Beginner	\N	Daily	Seeded assignment	\N
731	9	Approved	Intermediate	3	\N	Seeded request	\N
175	12	Approved	\N	\N	Daily	Seeded request	\N
345	22	Requested	\N	\N	Daily	Seeded request	\N
886	6	Requested	\N	3	Rarely	Seeded request	\N
651	23	Approved	Expert	\N	\N	Seeded request	2025-11-26 20:41:27.264874
216	6	Approved	\N	2	\N	Seeded assignment	\N
501	18	Approved	Expert	\N	Weekly	Seeded request	2025-11-28 04:24:27.264874
812	25	Requested	\N	\N	\N	Seeded request	2025-11-21 12:25:27.264874
5	7	Requested	\N	\N	Rarely	Seeded assignment	\N
765	24	Requested	\N	9	Monthly	Seeded assignment	2025-11-27 05:03:27.264874
536	7	Approved	\N	6	\N	Seeded assignment	2025-11-10 03:30:27.264874
719	7	Requested	Intermediate	4	Daily	Seeded request	\N
152	7	Requested	Intermediate	6	Monthly	Seeded assignment	\N
980	25	Approved	Advanced	\N	Monthly	Seeded request	\N
190	16	Requested	\N	0	\N	Seeded assignment	2025-11-20 22:24:27.264874
777	10	Requested	Expert	\N	Weekly	Seeded request	2025-11-04 14:26:27.264874
837	7	Requested	\N	2	Rarely	Seeded request	2025-12-01 01:47:27.264874
821	13	Approved	\N	10	Monthly	Seeded request	\N
967	13	Approved	Intermediate	3	Daily	Seeded assignment	\N
192	11	Requested	\N	10	Daily	Seeded assignment	\N
514	5	Approved	Advanced	5	Rarely	Seeded assignment	\N
444	23	Approved	Beginner	\N	\N	Seeded assignment	\N
33	25	Requested	Advanced	7	Weekly	Seeded assignment	\N
869	7	Approved	Intermediate	9	Rarely	Seeded assignment	\N
456	6	Approved	\N	5	Daily	Seeded assignment	\N
459	23	Approved	\N	\N	\N	Seeded assignment	\N
354	18	Requested	Beginner	3	Weekly	Seeded request	2025-11-05 09:06:27.264874
900	25	Requested	Beginner	7	Monthly	Seeded request	\N
44	22	Requested	Beginner	0	\N	Seeded assignment	\N
898	10	Requested	Advanced	10	\N	Seeded request	2025-11-24 22:10:27.264874
162	5	Approved	\N	\N	\N	Seeded assignment	\N
402	4	Approved	Advanced	\N	Weekly	Seeded request	\N
2	10	Requested	\N	0	\N	Seeded assignment	2025-11-09 04:55:27.264874
528	22	Requested	Intermediate	3	\N	Seeded assignment	\N
49	3	Requested	\N	\N	Daily	Seeded request	2025-11-04 03:10:27.264874
127	13	Requested	Intermediate	\N	Daily	Seeded assignment	\N
117	19	Approved	\N	9	\N	Seeded assignment	2025-11-07 23:02:27.264874
96	8	Requested	\N	\N	\N	Seeded assignment	2025-11-27 15:54:27.264874
713	12	Approved	\N	\N	Rarely	Seeded assignment	2025-11-10 07:17:27.264874
99	5	Approved	\N	\N	\N	Seeded assignment	2025-11-07 02:38:27.264874
138	4	Requested	\N	\N	\N	Seeded assignment	2025-11-25 22:45:27.264874
871	13	Requested	Advanced	9	\N	Seeded assignment	\N
148	16	Requested	Advanced	4	\N	Seeded request	\N
236	16	Requested	Beginner	3	Weekly	Seeded assignment	\N
410	4	Approved	Advanced	\N	\N	Seeded assignment	\N
372	3	Approved	Expert	7	\N	Seeded assignment	\N
769	12	Approved	Intermediate	6	\N	Seeded assignment	\N
179	13	Approved	Intermediate	1	Monthly	Seeded assignment	\N
778	18	Approved	\N	\N	\N	Seeded request	2025-11-03 13:52:27.264874
171	1	Requested	Intermediate	4	Monthly	Seeded request	\N
387	11	Requested	\N	\N	Weekly	Seeded assignment	\N
820	8	Approved	\N	\N	Rarely	Seeded request	\N
505	10	Requested	\N	9	Monthly	Seeded assignment	\N
591	12	Requested	\N	\N	\N	Seeded assignment	2025-11-15 13:48:27.264874
904	1	Requested	\N	3	\N	Seeded assignment	\N
114	19	Requested	Advanced	4	\N	Seeded request	\N
385	18	Approved	\N	\N	\N	Seeded assignment	2025-11-22 02:51:27.264874
588	17	Requested	Intermediate	8	Weekly	Seeded assignment	2025-12-02 03:40:27.264874
24	6	Approved	Beginner	0	Daily	Seeded assignment	\N
81	18	Requested	Expert	\N	Rarely	Seeded assignment	\N
134	12	Requested	Expert	4	Monthly	Seeded assignment	\N
985	13	Approved	Beginner	\N	\N	Seeded request	\N
684	10	Requested	Advanced	5	Daily	Seeded request	\N
929	9	Requested	Expert	1	\N	Seeded request	2025-12-02 03:46:27.264874
4	16	Requested	\N	3	\N	Seeded assignment	\N
143	10	Approved	Intermediate	\N	\N	Seeded request	\N
523	25	Requested	Advanced	8	\N	Seeded request	\N
823	17	Approved	Beginner	6	Daily	Seeded assignment	\N
848	10	Requested	Intermediate	3	Weekly	Seeded assignment	\N
614	10	Approved	Beginner	\N	Monthly	Seeded assignment	\N
960	9	Approved	Advanced	\N	Weekly	Seeded assignment	\N
596	7	Approved	\N	1	\N	Seeded request	\N
381	10	Approved	\N	5	Monthly	Seeded assignment	\N
469	3	Approved	\N	\N	Daily	Seeded assignment	\N
736	6	Requested	Advanced	\N	\N	Seeded assignment	2025-11-16 14:06:27.264874
54	1	Requested	\N	9	\N	Seeded assignment	\N
80	5	Approved	\N	8	Monthly	Seeded assignment	2025-11-13 15:34:27.264874
693	13	Approved	Advanced	0	Weekly	Seeded assignment	2025-12-01 17:25:27.264874
910	24	Approved	Expert	8	Rarely	Seeded assignment	\N
368	4	Approved	\N	10	\N	Seeded request	\N
19	8	Requested	\N	\N	Daily	Seeded assignment	\N
168	24	Approved	Expert	\N	\N	Seeded assignment	\N
458	17	Requested	Intermediate	9	Rarely	Seeded assignment	\N
959	13	Requested	\N	\N	Daily	Seeded request	2025-11-26 11:51:27.264874
200	4	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
629	17	Requested	Advanced	\N	Daily	Seeded assignment	\N
546	6	Approved	\N	6	\N	Seeded assignment	\N
810	1	Approved	Beginner	5	\N	Seeded assignment	\N
327	3	Approved	Intermediate	0	Monthly	Seeded request	\N
632	19	Approved	Intermediate	0	\N	Seeded request	\N
379	24	Requested	Beginner	3	Weekly	Seeded assignment	2025-11-19 11:27:27.264874
877	13	Approved	\N	\N	Daily	Seeded request	\N
706	21	Requested	\N	6	Rarely	Seeded request	2025-12-02 21:45:27.264874
717	13	Requested	Beginner	9	Rarely	Seeded request	2025-11-11 06:24:27.264874
52	6	Requested	Intermediate	5	Daily	Seeded request	2025-11-23 12:04:27.264874
138	3	Approved	Expert	6	Rarely	Seeded request	\N
255	10	Requested	\N	7	\N	Seeded request	2025-11-07 05:47:27.264874
372	4	Requested	Beginner	\N	Monthly	Seeded assignment	2025-11-17 17:11:27.264874
984	7	Approved	\N	1	Rarely	Seeded assignment	2025-11-30 09:54:27.264874
622	19	Approved	Beginner	8	Weekly	Seeded request	\N
145	25	Approved	Beginner	5	\N	Seeded request	2025-11-12 14:53:27.264874
704	8	Requested	\N	0	\N	Seeded assignment	2025-12-02 01:52:27.264874
36	9	Approved	Beginner	8	\N	Seeded assignment	2025-11-14 10:44:27.264874
402	3	Approved	Advanced	\N	\N	Seeded request	2025-11-20 00:48:27.264874
807	24	Approved	Intermediate	4	\N	Seeded assignment	\N
66	10	Approved	Beginner	7	Rarely	Seeded assignment	\N
913	6	Requested	\N	5	\N	Seeded assignment	2025-11-27 00:23:27.264874
307	21	Requested	Intermediate	\N	Rarely	Seeded assignment	2025-11-12 10:08:27.264874
163	25	Requested	\N	\N	Monthly	Seeded assignment	2025-11-04 11:44:27.264874
631	7	Approved	Advanced	5	\N	Seeded request	2025-11-25 10:20:27.264874
449	21	Requested	Advanced	6	Daily	Seeded assignment	2025-11-19 00:44:27.264874
417	5	Approved	\N	6	Rarely	Seeded assignment	\N
1	4	Requested	Advanced	1	Daily	Seeded assignment	\N
608	16	Requested	Intermediate	10	\N	Seeded request	\N
677	4	Approved	Beginner	2	Rarely	Seeded assignment	\N
100	8	Approved	Advanced	\N	Rarely	Seeded request	\N
899	21	Approved	Beginner	6	\N	Seeded assignment	\N
811	5	Requested	Advanced	\N	\N	Seeded request	2025-12-02 15:37:27.264874
310	24	Approved	Intermediate	2	Weekly	Seeded request	\N
195	19	Requested	Intermediate	4	Monthly	Seeded request	2025-11-03 10:34:27.264874
860	16	Requested	\N	1	Weekly	Seeded request	\N
83	7	Requested	\N	6	\N	Seeded assignment	\N
369	11	Approved	\N	6	\N	Seeded assignment	\N
425	1	Approved	Beginner	3	Rarely	Seeded assignment	\N
768	16	Requested	Advanced	\N	\N	Seeded request	\N
252	17	Requested	Intermediate	\N	\N	Seeded request	\N
462	23	Approved	Beginner	3	\N	Seeded assignment	2025-11-04 20:39:27.264874
769	20	Approved	\N	6	Monthly	Seeded assignment	\N
5	23	Approved	Advanced	0	Weekly	Seeded request	\N
438	13	Requested	Advanced	\N	\N	Seeded assignment	\N
196	21	Requested	\N	5	\N	Seeded request	\N
829	16	Approved	Advanced	\N	Daily	Seeded assignment	\N
651	7	Approved	Expert	\N	Rarely	Seeded request	2025-11-23 00:58:27.264874
789	23	Requested	Advanced	\N	Monthly	Seeded assignment	\N
816	17	Requested	Intermediate	6	\N	Seeded request	\N
858	9	Requested	\N	\N	Daily	Seeded request	2025-11-24 03:35:27.264874
743	16	Approved	Expert	\N	Rarely	Seeded request	\N
536	23	Approved	Expert	1	Monthly	Seeded request	\N
191	10	Approved	\N	\N	Weekly	Seeded request	\N
664	24	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-23 15:59:27.264874
623	19	Approved	\N	8	\N	Seeded assignment	\N
914	17	Requested	\N	5	Weekly	Seeded request	2025-11-30 14:04:27.264874
227	9	Approved	\N	\N	Daily	Seeded assignment	\N
469	4	Approved	\N	3	Weekly	Seeded assignment	\N
39	10	Approved	Intermediate	8	Rarely	Seeded assignment	\N
509	20	Approved	\N	1	Daily	Seeded request	2025-11-09 01:41:27.264874
814	22	Approved	Beginner	10	\N	Seeded assignment	\N
112	6	Requested	Beginner	5	\N	Seeded assignment	\N
905	4	Approved	\N	\N	\N	Seeded assignment	2025-11-23 10:33:27.264874
752	25	Requested	Advanced	1	Rarely	Seeded request	2025-11-23 14:05:27.264874
98	25	Approved	Beginner	6	\N	Seeded assignment	\N
349	13	Requested	\N	\N	Daily	Seeded assignment	\N
968	12	Requested	Advanced	1	Daily	Seeded request	\N
520	18	Approved	\N	4	\N	Seeded request	2025-11-24 12:39:27.264874
958	17	Approved	Advanced	\N	\N	Seeded request	\N
983	6	Requested	Beginner	1	Daily	Seeded assignment	\N
74	20	Approved	\N	8	Daily	Seeded assignment	\N
795	13	Approved	\N	0	\N	Seeded assignment	2025-11-30 11:50:27.264874
869	23	Requested	\N	10	Weekly	Seeded assignment	2025-11-10 19:46:27.264874
193	25	Requested	\N	7	\N	Seeded assignment	2025-11-17 19:30:27.264874
45	4	Approved	Expert	\N	Weekly	Seeded request	\N
726	3	Approved	\N	\N	Daily	Seeded request	2025-11-07 07:55:27.264874
293	23	Approved	Beginner	8	Monthly	Seeded request	2025-11-04 16:11:27.264874
835	18	Approved	\N	\N	Weekly	Seeded request	\N
894	16	Approved	Expert	1	Weekly	Seeded assignment	\N
243	25	Approved	Intermediate	\N	Monthly	Seeded assignment	2025-11-29 21:27:27.264874
853	25	Requested	\N	0	Weekly	Seeded assignment	\N
48	19	Requested	\N	\N	\N	Seeded request	\N
861	17	Approved	\N	4	\N	Seeded assignment	2025-12-02 23:36:27.264874
86	1	Approved	Advanced	\N	Weekly	Seeded assignment	\N
510	16	Requested	\N	\N	Weekly	Seeded request	\N
671	4	Approved	\N	\N	\N	Seeded assignment	\N
84	20	Approved	Expert	2	Rarely	Seeded request	2025-11-30 01:54:27.264874
562	22	Requested	\N	\N	Rarely	Seeded request	2025-11-13 13:45:27.264874
948	3	Approved	Intermediate	\N	Rarely	Seeded request	\N
346	7	Approved	Beginner	\N	\N	Seeded assignment	2025-11-25 11:47:27.264874
76	11	Requested	\N	10	Daily	Seeded assignment	\N
359	21	Approved	Advanced	\N	Monthly	Seeded request	\N
790	16	Requested	Expert	5	Daily	Seeded request	\N
322	20	Approved	\N	7	\N	Seeded assignment	2025-11-20 22:09:27.264874
520	4	Approved	Beginner	\N	Monthly	Seeded assignment	\N
780	12	Requested	Intermediate	7	Rarely	Seeded assignment	\N
464	1	Approved	Advanced	\N	\N	Seeded assignment	\N
923	17	Requested	\N	1	Weekly	Seeded assignment	\N
331	19	Approved	\N	\N	Monthly	Seeded request	\N
874	19	Requested	Beginner	10	Monthly	Seeded assignment	\N
826	1	Approved	Intermediate	4	\N	Seeded assignment	\N
9	19	Requested	Expert	\N	Rarely	Seeded assignment	2025-11-22 00:17:27.264874
115	20	Approved	\N	\N	\N	Seeded request	2025-11-04 23:17:27.264874
844	4	Approved	\N	8	Rarely	Seeded request	\N
177	7	Approved	\N	\N	Rarely	Seeded request	\N
906	12	Requested	\N	\N	Monthly	Seeded assignment	\N
977	17	Requested	\N	8	Monthly	Seeded request	\N
244	24	Requested	\N	7	Monthly	Seeded assignment	\N
508	23	Approved	Advanced	9	Weekly	Seeded assignment	\N
81	3	Approved	\N	3	Daily	Seeded request	2025-12-02 10:43:27.264874
385	3	Approved	Intermediate	2	Monthly	Seeded assignment	2025-11-14 04:39:27.264874
515	17	Requested	Beginner	10	Monthly	Seeded assignment	\N
716	5	Approved	Intermediate	8	Rarely	Seeded assignment	2025-11-22 06:30:27.264874
476	13	Approved	\N	2	\N	Seeded assignment	2025-11-28 12:59:27.264874
934	16	Approved	Intermediate	4	Rarely	Seeded assignment	\N
315	7	Approved	Beginner	\N	Weekly	Seeded assignment	\N
14	13	Approved	Advanced	3	Monthly	Seeded assignment	\N
530	21	Approved	Intermediate	10	Rarely	Seeded assignment	\N
123	25	Requested	\N	\N	Rarely	Seeded request	\N
830	9	Approved	\N	\N	\N	Seeded request	\N
766	20	Approved	\N	\N	Monthly	Seeded request	2025-11-29 06:25:27.264874
350	3	Approved	\N	\N	Daily	Seeded assignment	\N
406	1	Requested	Advanced	\N	\N	Seeded assignment	2025-11-25 12:08:27.264874
815	23	Requested	\N	4	\N	Seeded request	2025-11-12 23:06:27.264874
29	9	Approved	Advanced	\N	Monthly	Seeded request	\N
311	20	Approved	Intermediate	10	Daily	Seeded assignment	\N
833	23	Requested	Intermediate	3	\N	Seeded assignment	\N
189	17	Requested	\N	6	Daily	Seeded request	\N
734	3	Approved	Advanced	0	Monthly	Seeded assignment	\N
753	19	Approved	\N	8	\N	Seeded assignment	\N
415	12	Requested	Intermediate	8	\N	Seeded assignment	2025-11-20 16:27:27.264874
969	6	Approved	Expert	\N	Monthly	Seeded assignment	\N
884	5	Approved	Intermediate	8	Monthly	Seeded assignment	\N
721	16	Requested	Beginner	3	\N	Seeded request	\N
951	4	Requested	Beginner	\N	Daily	Seeded request	\N
616	19	Approved	Intermediate	\N	Daily	Seeded request	\N
748	17	Approved	Intermediate	0	Monthly	Seeded request	2025-11-08 22:43:27.264874
126	22	Approved	\N	\N	Monthly	Seeded request	2025-11-24 08:29:27.264874
239	23	Approved	\N	3	Weekly	Seeded assignment	2025-11-06 06:14:27.264874
176	5	Approved	\N	\N	Daily	Seeded assignment	2025-12-01 13:42:27.264874
863	21	Approved	\N	0	Daily	Seeded request	\N
677	18	Approved	\N	\N	Monthly	Seeded assignment	\N
450	9	Approved	Expert	\N	\N	Seeded assignment	\N
727	25	Requested	Advanced	10	Weekly	Seeded assignment	2025-11-12 02:25:27.264874
569	10	Approved	Expert	5	Daily	Seeded assignment	\N
781	25	Approved	Intermediate	\N	Daily	Seeded request	\N
222	20	Approved	Beginner	10	Weekly	Seeded request	2025-11-06 07:05:27.264874
431	5	Approved	\N	\N	Weekly	Seeded assignment	\N
746	5	Requested	Intermediate	9	\N	Seeded assignment	2025-11-21 20:43:27.264874
57	23	Requested	Intermediate	5	\N	Seeded assignment	\N
718	21	Approved	\N	5	Monthly	Seeded assignment	\N
273	9	Requested	\N	4	Monthly	Seeded assignment	\N
429	21	Approved	\N	\N	Daily	Seeded request	\N
552	9	Requested	\N	\N	\N	Seeded assignment	\N
224	16	Requested	Intermediate	8	\N	Seeded request	2025-12-02 05:45:27.264874
424	7	Approved	Expert	4	Weekly	Seeded assignment	2025-11-06 21:32:27.264874
400	25	Approved	\N	\N	\N	Seeded request	\N
213	6	Requested	Expert	8	\N	Seeded assignment	\N
922	1	Approved	Advanced	\N	Weekly	Seeded assignment	\N
473	25	Approved	Intermediate	\N	\N	Seeded assignment	\N
822	21	Requested	\N	2	Weekly	Seeded assignment	2025-11-14 08:07:27.264874
166	5	Approved	Expert	1	Weekly	Seeded assignment	\N
237	12	Approved	Beginner	3	Weekly	Seeded assignment	2025-11-29 11:10:27.264874
742	22	Requested	Intermediate	7	Rarely	Seeded assignment	2025-11-28 23:59:27.264874
246	3	Approved	\N	10	\N	Seeded assignment	\N
203	16	Requested	\N	8	Monthly	Seeded assignment	2025-11-12 11:32:27.264874
724	1	Approved	Beginner	\N	\N	Seeded request	\N
82	6	Requested	\N	1	Daily	Seeded request	\N
500	10	Approved	\N	8	Daily	Seeded request	\N
360	12	Requested	\N	7	Daily	Seeded assignment	\N
968	22	Requested	Advanced	\N	Rarely	Seeded assignment	\N
88	19	Approved	Intermediate	\N	Monthly	Seeded request	\N
13	10	Approved	\N	9	Monthly	Seeded assignment	\N
338	9	Approved	\N	\N	Daily	Seeded assignment	\N
144	5	Approved	\N	\N	\N	Seeded request	\N
269	3	Requested	Expert	\N	\N	Seeded assignment	\N
202	21	Requested	Advanced	7	\N	Seeded request	2025-11-16 20:12:27.264874
695	25	Requested	Beginner	7	Monthly	Seeded request	2025-11-07 21:10:27.264874
46	10	Approved	Beginner	\N	Daily	Seeded assignment	\N
217	13	Approved	\N	9	Rarely	Seeded request	\N
607	1	Approved	\N	10	Daily	Seeded assignment	\N
615	5	Requested	\N	\N	Monthly	Seeded assignment	2025-11-24 11:04:27.264874
174	12	Approved	\N	1	\N	Seeded assignment	\N
953	5	Requested	Intermediate	6	Monthly	Seeded assignment	\N
47	17	Approved	Intermediate	8	Weekly	Seeded request	2025-11-27 07:31:27.264874
775	24	Requested	\N	\N	Rarely	Seeded assignment	2025-11-28 00:34:27.264874
534	3	Approved	Advanced	\N	\N	Seeded request	\N
987	21	Approved	\N	3	Monthly	Seeded request	2025-11-18 10:44:27.264874
932	22	Requested	\N	\N	\N	Seeded assignment	\N
558	3	Requested	Beginner	6	Weekly	Seeded assignment	\N
59	16	Approved	\N	\N	Weekly	Seeded request	\N
493	24	Approved	Expert	\N	\N	Seeded assignment	\N
424	23	Requested	\N	\N	Rarely	Seeded assignment	2025-11-12 13:11:27.264874
111	20	Approved	Beginner	4	\N	Seeded assignment	\N
407	18	Approved	\N	5	\N	Seeded assignment	2025-11-23 03:33:27.264874
206	20	Requested	Expert	9	Rarely	Seeded assignment	2025-11-23 08:30:27.264874
423	19	Approved	Intermediate	10	\N	Seeded assignment	\N
502	16	Approved	\N	\N	Rarely	Seeded request	\N
512	7	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-24 01:57:27.264874
284	7	Approved	\N	\N	\N	Seeded request	\N
379	8	Requested	\N	7	\N	Seeded request	\N
580	22	Approved	\N	9	Weekly	Seeded assignment	\N
772	5	Requested	\N	\N	Monthly	Seeded request	2025-11-15 18:49:27.264874
720	22	Requested	\N	\N	Weekly	Seeded request	\N
280	17	Requested	Advanced	10	Rarely	Seeded request	2025-11-11 22:32:27.264874
54	11	Requested	Beginner	\N	Weekly	Seeded assignment	\N
67	3	Requested	Expert	2	Daily	Seeded assignment	\N
479	7	Approved	Beginner	8	\N	Seeded assignment	2025-11-06 11:30:27.264874
261	10	Requested	\N	6	Rarely	Seeded assignment	\N
222	12	Requested	Expert	4	Monthly	Seeded assignment	\N
557	4	Approved	\N	8	\N	Seeded request	\N
516	22	Approved	\N	0	Weekly	Seeded request	\N
890	20	Requested	Intermediate	1	Monthly	Seeded request	2025-11-27 18:48:27.264874
749	5	Requested	Expert	7	Monthly	Seeded assignment	\N
371	18	Approved	\N	2	\N	Seeded request	2025-11-24 08:46:27.264874
488	22	Approved	Intermediate	6	Weekly	Seeded request	2025-11-04 00:59:27.264874
465	7	Requested	\N	\N	\N	Seeded assignment	\N
258	24	Approved	\N	\N	Weekly	Seeded assignment	2025-11-11 20:22:27.264874
814	20	Requested	Intermediate	\N	\N	Seeded assignment	\N
925	13	Requested	\N	5	\N	Seeded assignment	\N
652	21	Requested	Expert	\N	\N	Seeded assignment	2025-12-03 03:44:27.264874
68	21	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-10 11:41:27.264874
538	13	Approved	Beginner	\N	Daily	Seeded assignment	\N
711	5	Requested	Advanced	1	Monthly	Seeded request	\N
219	1	Approved	\N	1	Weekly	Seeded assignment	\N
606	6	Requested	\N	6	Weekly	Seeded request	\N
248	16	Approved	Beginner	\N	Rarely	Seeded request	\N
347	18	Approved	\N	\N	\N	Seeded request	\N
552	1	Approved	Intermediate	\N	\N	Seeded assignment	\N
238	8	Requested	Advanced	10	Weekly	Seeded request	\N
843	23	Approved	Beginner	\N	\N	Seeded assignment	\N
159	4	Requested	Advanced	5	\N	Seeded assignment	\N
567	3	Approved	\N	0	Daily	Seeded request	\N
79	1	Requested	Expert	\N	Weekly	Seeded assignment	\N
392	24	Approved	\N	\N	Rarely	Seeded assignment	\N
311	12	Approved	\N	8	\N	Seeded assignment	\N
302	9	Approved	Expert	\N	Daily	Seeded assignment	\N
955	3	Approved	\N	\N	Monthly	Seeded assignment	\N
177	23	Requested	\N	6	Rarely	Seeded assignment	2025-11-24 20:55:27.264874
273	1	Requested	\N	10	Rarely	Seeded assignment	\N
658	3	Approved	Intermediate	\N	Monthly	Seeded assignment	2025-11-18 13:25:27.264874
715	22	Approved	\N	2	Rarely	Seeded assignment	\N
857	11	Approved	\N	6	Monthly	Seeded request	2025-11-17 04:38:27.264874
418	16	Approved	Expert	\N	\N	Seeded request	\N
696	10	Approved	Beginner	9	Rarely	Seeded assignment	2025-11-07 07:44:27.264874
792	13	Approved	\N	5	\N	Seeded assignment	2025-11-21 02:46:27.264874
892	21	Approved	Advanced	\N	Rarely	Seeded assignment	\N
891	17	Requested	\N	10	\N	Seeded request	\N
351	9	Approved	\N	\N	\N	Seeded assignment	\N
451	11	Requested	Advanced	10	\N	Seeded request	2025-12-03 04:22:27.264874
410	18	Approved	\N	9	\N	Seeded request	2025-11-28 13:47:27.264874
878	13	Requested	\N	7	Daily	Seeded assignment	\N
882	7	Approved	Expert	6	Rarely	Seeded assignment	2025-11-30 02:00:27.264874
207	16	Approved	Intermediate	\N	Weekly	Seeded request	\N
761	3	Approved	Intermediate	2	Weekly	Seeded assignment	2025-11-28 04:38:27.264874
173	13	Approved	Beginner	3	Daily	Seeded assignment	\N
460	3	Approved	\N	2	\N	Seeded request	2025-11-14 19:03:27.264874
271	1	Approved	Intermediate	\N	Rarely	Seeded assignment	\N
547	25	Requested	Intermediate	\N	\N	Seeded request	\N
211	17	Approved	Expert	7	\N	Seeded request	\N
306	5	Approved	Beginner	\N	\N	Seeded assignment	\N
391	10	Requested	Intermediate	3	Rarely	Seeded assignment	2025-11-06 08:41:27.264874
907	5	Requested	Beginner	8	Rarely	Seeded request	\N
463	16	Approved	\N	1	Daily	Seeded assignment	2025-11-09 21:40:27.264874
11	7	Requested	Intermediate	4	Monthly	Seeded assignment	2025-11-30 02:34:27.264874
320	10	Requested	\N	\N	Daily	Seeded assignment	2025-11-05 13:08:27.264874
556	25	Approved	Advanced	\N	Rarely	Seeded request	\N
491	5	Approved	Beginner	8	\N	Seeded request	\N
733	8	Approved	Intermediate	\N	Rarely	Seeded assignment	\N
448	5	Approved	\N	7	Monthly	Seeded request	\N
833	7	Requested	\N	0	Monthly	Seeded assignment	\N
678	18	Approved	\N	\N	\N	Seeded assignment	2025-11-18 12:18:27.264874
906	20	Approved	Advanced	\N	\N	Seeded assignment	2025-11-24 23:01:27.264874
115	12	Requested	\N	\N	\N	Seeded assignment	\N
64	23	Approved	\N	\N	\N	Seeded assignment	\N
922	9	Approved	Advanced	\N	Daily	Seeded request	2025-12-01 06:43:27.264874
153	17	Approved	Expert	7	Monthly	Seeded assignment	\N
963	5	Requested	\N	2	Rarely	Seeded assignment	2025-11-16 05:59:27.264874
257	13	Requested	Expert	7	\N	Seeded request	2025-11-21 22:46:27.264874
186	6	Approved	\N	8	\N	Seeded assignment	2025-11-16 19:42:27.264874
675	3	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
388	20	Approved	Expert	8	\N	Seeded assignment	\N
434	9	Approved	\N	7	Monthly	Seeded request	\N
446	9	Requested	Expert	\N	Daily	Seeded request	\N
891	21	Approved	Expert	6	Weekly	Seeded assignment	2025-11-04 04:54:27.264874
262	1	Requested	\N	8	\N	Seeded request	2025-11-30 07:17:27.264874
313	1	Approved	\N	5	Monthly	Seeded request	2025-11-06 02:09:27.264874
176	20	Approved	Expert	\N	\N	Seeded request	\N
92	5	Approved	\N	\N	\N	Seeded assignment	\N
232	17	Approved	Beginner	9	Daily	Seeded request	2025-11-03 23:41:27.264874
533	6	Approved	Advanced	8	\N	Seeded assignment	\N
585	1	Approved	\N	\N	Monthly	Seeded request	2025-11-21 23:17:27.264874
99	22	Approved	Intermediate	9	\N	Seeded assignment	2025-11-19 13:50:27.264874
135	8	Requested	Expert	\N	Rarely	Seeded request	2025-11-06 01:04:27.264874
228	8	Requested	Intermediate	\N	\N	Seeded assignment	\N
729	21	Requested	\N	0	\N	Seeded assignment	2025-11-16 20:58:27.264874
936	13	Approved	\N	10	Monthly	Seeded assignment	2025-11-08 15:16:27.264874
140	21	Approved	Beginner	9	Daily	Seeded assignment	\N
125	21	Approved	Intermediate	10	\N	Seeded assignment	\N
959	16	Approved	\N	10	Weekly	Seeded request	\N
363	3	Approved	Expert	\N	Rarely	Seeded assignment	\N
647	23	Approved	Beginner	0	\N	Seeded request	\N
129	4	Requested	Intermediate	\N	Monthly	Seeded request	2025-11-08 01:17:27.264874
195	4	Requested	Expert	9	\N	Seeded request	\N
153	21	Approved	\N	\N	Rarely	Seeded request	2025-11-18 11:58:27.264874
531	1	Requested	Beginner	\N	Daily	Seeded request	2025-11-20 00:17:27.264874
163	6	Requested	Beginner	\N	Daily	Seeded assignment	\N
883	7	Approved	\N	9	\N	Seeded assignment	2025-12-01 11:39:27.264874
97	9	Requested	Intermediate	4	Monthly	Seeded assignment	2025-11-16 20:50:27.264874
174	5	Approved	Advanced	\N	\N	Seeded assignment	2025-11-13 01:46:27.264874
930	4	Approved	\N	\N	Monthly	Seeded assignment	2025-11-15 16:40:27.264874
211	21	Requested	Advanced	0	Daily	Seeded assignment	\N
701	17	Requested	Beginner	2	Daily	Seeded assignment	\N
903	4	Approved	Beginner	2	Monthly	Seeded request	2025-11-20 06:03:27.264874
370	16	Approved	\N	\N	\N	Seeded assignment	\N
601	23	Approved	Intermediate	0	Daily	Seeded assignment	\N
62	22	Requested	Expert	6	Rarely	Seeded assignment	\N
106	23	Approved	Intermediate	8	Daily	Seeded request	\N
956	6	Approved	Advanced	\N	\N	Seeded request	\N
681	23	Requested	Intermediate	\N	Weekly	Seeded assignment	\N
58	19	Requested	\N	7	\N	Seeded assignment	2025-11-05 21:34:27.264874
657	20	Requested	Advanced	3	Weekly	Seeded request	\N
809	1	Approved	\N	9	\N	Seeded request	\N
676	3	Requested	Intermediate	2	Rarely	Seeded request	2025-12-02 08:47:27.264874
753	18	Approved	\N	7	Monthly	Seeded request	\N
821	16	Approved	Intermediate	0	Daily	Seeded request	\N
409	3	Requested	Advanced	\N	Rarely	Seeded request	\N
732	16	Approved	\N	\N	Daily	Seeded request	2025-11-29 07:39:27.264874
672	6	Approved	Intermediate	10	\N	Seeded assignment	\N
517	13	Approved	\N	\N	Daily	Seeded request	\N
242	13	Approved	\N	9	Rarely	Seeded request	2025-11-19 14:23:27.264874
8	1	Requested	Advanced	0	\N	Seeded request	\N
305	22	Requested	\N	\N	Weekly	Seeded request	2025-11-24 14:51:27.264874
592	12	Approved	Beginner	\N	Rarely	Seeded request	\N
907	12	Approved	Advanced	3	Monthly	Seeded assignment	\N
827	8	Approved	Intermediate	5	\N	Seeded assignment	\N
272	11	Requested	Expert	\N	Daily	Seeded assignment	\N
648	13	Requested	\N	\N	\N	Seeded assignment	\N
223	11	Requested	Advanced	9	Weekly	Seeded request	\N
286	3	Approved	Expert	3	\N	Seeded assignment	\N
422	19	Requested	Expert	\N	\N	Seeded assignment	\N
865	17	Approved	Expert	\N	Monthly	Seeded assignment	\N
78	10	Requested	Expert	6	\N	Seeded assignment	2025-11-26 04:22:27.264874
539	13	Requested	Expert	4	\N	Seeded assignment	\N
243	6	Requested	Advanced	8	\N	Seeded request	\N
298	25	Requested	Expert	\N	Weekly	Seeded request	\N
405	7	Approved	Beginner	\N	Monthly	Seeded request	\N
467	13	Requested	\N	5	Rarely	Seeded assignment	\N
620	23	Approved	Beginner	\N	Rarely	Seeded assignment	2025-12-02 18:13:27.264874
916	20	Requested	\N	1	Monthly	Seeded assignment	\N
91	24	Approved	Intermediate	0	\N	Seeded assignment	2025-11-25 10:11:27.264874
180	16	Approved	Expert	\N	Weekly	Seeded request	2025-11-12 01:31:27.264874
542	1	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-26 17:13:27.264874
175	22	Approved	Beginner	2	Weekly	Seeded assignment	2025-11-14 10:53:27.264874
808	18	Approved	\N	4	Daily	Seeded assignment	\N
641	3	Approved	\N	5	\N	Seeded assignment	\N
204	4	Approved	\N	\N	Rarely	Seeded request	2025-11-16 04:51:27.264874
494	17	Approved	\N	4	Monthly	Seeded assignment	2025-11-08 22:57:27.264874
535	17	Requested	\N	5	Daily	Seeded assignment	\N
671	19	Approved	Intermediate	1	\N	Seeded request	2025-11-04 15:02:27.264874
690	25	Approved	\N	3	\N	Seeded request	\N
68	17	Approved	\N	\N	\N	Seeded assignment	\N
100	10	Approved	\N	2	Daily	Seeded assignment	\N
972	18	Requested	\N	8	Weekly	Seeded assignment	\N
411	18	Requested	Beginner	1	\N	Seeded assignment	2025-11-03 18:27:27.264874
95	4	Requested	\N	9	\N	Seeded assignment	\N
7	11	Approved	Intermediate	\N	Daily	Seeded request	2025-11-17 03:38:27.264874
854	13	Requested	\N	4	Rarely	Seeded assignment	\N
183	12	Requested	Advanced	10	Weekly	Seeded assignment	\N
485	24	Approved	\N	4	\N	Seeded assignment	\N
280	21	Approved	\N	4	\N	Seeded assignment	2025-11-14 21:51:27.264874
686	6	Requested	Intermediate	9	Weekly	Seeded request	\N
798	18	Approved	\N	8	Rarely	Seeded assignment	\N
127	16	Approved	\N	\N	Daily	Seeded request	\N
199	19	Requested	Advanced	1	Daily	Seeded request	\N
389	3	Requested	\N	\N	\N	Seeded request	\N
428	6	Approved	Beginner	0	Weekly	Seeded request	2025-11-28 09:34:27.264874
10	6	Approved	Expert	\N	Daily	Seeded assignment	\N
585	9	Approved	Beginner	3	\N	Seeded request	\N
401	21	Approved	\N	9	\N	Seeded request	\N
598	12	Approved	Expert	10	Daily	Seeded assignment	\N
570	21	Approved	\N	\N	Monthly	Seeded assignment	\N
417	22	Requested	\N	\N	Weekly	Seeded request	2025-11-23 19:32:27.264874
482	11	Requested	\N	\N	Monthly	Seeded request	2025-11-05 09:14:27.264874
34	8	Approved	Beginner	\N	\N	Seeded request	\N
884	12	Approved	\N	0	Monthly	Seeded request	\N
971	3	Approved	Beginner	5	\N	Seeded assignment	\N
472	12	Approved	\N	5	\N	Seeded request	2025-11-24 00:38:27.264874
439	16	Approved	\N	7	Daily	Seeded request	\N
678	19	Requested	Intermediate	\N	Monthly	Seeded request	\N
930	3	Approved	\N	\N	Rarely	Seeded assignment	\N
668	5	Approved	\N	\N	Rarely	Seeded request	\N
728	25	Approved	Intermediate	4	Weekly	Seeded assignment	\N
748	21	Approved	Expert	3	Daily	Seeded request	\N
18	8	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-19 07:36:27.264874
775	10	Approved	Beginner	2	\N	Seeded assignment	\N
262	9	Approved	\N	5	Daily	Seeded assignment	2025-11-25 02:22:27.264874
129	3	Approved	Advanced	3	Daily	Seeded assignment	\N
165	21	Approved	Beginner	\N	\N	Seeded assignment	2025-11-16 09:29:27.264874
900	6	Approved	\N	3	Rarely	Seeded assignment	\N
743	13	Approved	Beginner	3	\N	Seeded request	\N
405	23	Approved	Advanced	\N	Monthly	Seeded request	\N
518	7	Requested	Beginner	\N	Rarely	Seeded request	2025-11-11 01:27:27.264874
863	17	Approved	\N	\N	Daily	Seeded request	2025-11-10 22:51:27.264874
225	13	Requested	Beginner	8	\N	Seeded assignment	\N
760	13	Approved	\N	7	Daily	Seeded request	\N
46	24	Approved	\N	4	Daily	Seeded assignment	2025-11-05 20:16:27.264874
975	5	Requested	Advanced	\N	Weekly	Seeded request	\N
434	1	Approved	Beginner	3	Rarely	Seeded assignment	2025-11-17 23:57:27.264874
381	8	Approved	Advanced	2	\N	Seeded assignment	2025-11-21 01:59:27.264874
757	20	Approved	Advanced	9	\N	Seeded assignment	2025-11-16 23:18:27.264874
161	12	Approved	\N	\N	\N	Seeded assignment	\N
332	24	Approved	\N	\N	Weekly	Seeded request	\N
510	13	Approved	Beginner	\N	\N	Seeded assignment	2025-11-23 08:32:27.264874
731	11	Approved	Advanced	\N	Monthly	Seeded request	2025-12-01 12:40:27.264874
981	5	Approved	\N	8	\N	Seeded assignment	2025-11-16 13:29:27.264874
137	23	Approved	Beginner	10	\N	Seeded assignment	2025-11-28 19:11:27.264874
907	20	Requested	\N	10	Monthly	Seeded request	2025-11-18 18:36:27.264874
117	4	Requested	\N	9	Weekly	Seeded request	\N
349	16	Requested	Beginner	7	Monthly	Seeded assignment	\N
448	20	Approved	Advanced	9	Weekly	Seeded request	2025-12-01 14:50:27.264874
795	16	Requested	Intermediate	3	\N	Seeded assignment	2025-11-05 18:20:27.264874
277	24	Approved	Expert	\N	Rarely	Seeded assignment	\N
669	4	Requested	\N	\N	Monthly	Seeded assignment	\N
896	17	Requested	Intermediate	2	Rarely	Seeded request	\N
360	5	Approved	Advanced	8	Monthly	Seeded assignment	\N
546	25	Approved	\N	\N	Rarely	Seeded assignment	\N
178	6	Requested	Advanced	4	\N	Seeded request	\N
577	7	Approved	Intermediate	7	Weekly	Seeded assignment	\N
220	12	Approved	Intermediate	\N	\N	Seeded request	2025-11-15 05:10:27.264874
740	20	Requested	Expert	0	Rarely	Seeded request	\N
48	3	Approved	\N	1	\N	Seeded assignment	\N
717	16	Requested	Beginner	\N	Weekly	Seeded assignment	\N
839	6	Approved	Advanced	7	\N	Seeded request	\N
950	16	Approved	Advanced	\N	Weekly	Seeded assignment	\N
582	8	Requested	Beginner	\N	\N	Seeded request	\N
923	21	Approved	Beginner	\N	Weekly	Seeded assignment	\N
8	9	Approved	\N	7	Rarely	Seeded assignment	\N
526	6	Requested	Advanced	\N	\N	Seeded assignment	\N
559	6	Approved	Intermediate	\N	\N	Seeded assignment	\N
902	11	Approved	\N	3	\N	Seeded assignment	\N
275	19	Requested	Intermediate	8	Daily	Seeded request	\N
102	8	Approved	Intermediate	\N	\N	Seeded assignment	\N
898	8	Approved	Intermediate	2	Weekly	Seeded assignment	\N
189	21	Approved	Beginner	\N	\N	Seeded request	2025-11-20 18:32:27.264874
286	4	Approved	\N	\N	\N	Seeded request	\N
637	25	Approved	Expert	10	Weekly	Seeded assignment	\N
2	8	Approved	Expert	\N	Daily	Seeded request	\N
200	19	Approved	Advanced	\N	\N	Seeded request	\N
799	16	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
487	1	Approved	\N	8	Weekly	Seeded request	\N
283	20	Approved	Expert	\N	Daily	Seeded assignment	\N
942	23	Requested	\N	5	\N	Seeded request	2025-11-22 13:28:27.264874
221	17	Approved	Advanced	\N	\N	Seeded request	\N
623	3	Requested	Expert	\N	\N	Seeded assignment	\N
602	11	Approved	Beginner	0	\N	Seeded request	2025-11-04 00:54:27.264874
184	25	Approved	\N	\N	\N	Seeded request	\N
986	4	Approved	Beginner	\N	\N	Seeded assignment	2025-11-10 09:51:27.264874
648	8	Approved	Beginner	5	\N	Seeded assignment	2025-11-22 16:18:27.264874
418	24	Requested	Intermediate	10	Rarely	Seeded request	2025-11-22 08:19:27.264874
599	20	Approved	\N	1	Monthly	Seeded request	\N
954	1	Approved	Advanced	1	Rarely	Seeded request	2025-11-23 10:11:27.264874
539	8	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
467	8	Approved	Beginner	\N	Daily	Seeded assignment	\N
498	16	Requested	\N	1	Weekly	Seeded request	2025-11-14 11:26:27.264874
276	20	Requested	\N	1	Rarely	Seeded assignment	\N
66	13	Requested	Intermediate	3	\N	Seeded request	\N
27	18	Approved	\N	6	\N	Seeded request	2025-11-24 02:23:27.264874
432	4	Approved	\N	\N	\N	Seeded request	2025-12-03 04:13:27.264874
797	23	Requested	\N	\N	\N	Seeded assignment	2025-11-08 00:04:27.264874
846	4	Approved	Advanced	10	Monthly	Seeded assignment	2025-11-10 06:50:27.264874
697	17	Requested	Advanced	4	\N	Seeded assignment	2025-11-09 21:14:27.264874
435	1	Approved	\N	2	\N	Seeded request	2025-11-16 05:42:27.264874
421	3	Requested	\N	5	Rarely	Seeded request	\N
553	17	Approved	Beginner	\N	Rarely	Seeded assignment	2025-11-08 03:05:27.264874
517	8	Requested	\N	7	Monthly	Seeded request	2025-11-26 11:18:27.264874
414	12	Requested	\N	2	Rarely	Seeded assignment	\N
213	11	Approved	\N	8	Daily	Seeded assignment	2025-11-24 13:00:27.264874
786	12	Approved	\N	0	Monthly	Seeded request	2025-11-10 00:53:27.264874
383	7	Requested	Beginner	\N	Weekly	Seeded request	2025-11-20 04:50:27.264874
942	18	Approved	Advanced	\N	Rarely	Seeded assignment	2025-11-24 01:52:27.264874
324	19	Approved	\N	\N	\N	Seeded assignment	2025-11-06 01:48:27.264874
593	4	Approved	\N	4	\N	Seeded assignment	2025-11-15 10:45:27.264874
738	13	Approved	\N	\N	Daily	Seeded request	2025-11-12 10:46:27.264874
216	9	Approved	\N	\N	\N	Seeded request	2025-12-01 02:41:27.264874
573	23	Requested	\N	2	\N	Seeded assignment	\N
88	7	Requested	\N	10	Weekly	Seeded assignment	\N
888	8	Approved	\N	8	\N	Seeded request	2025-11-17 00:42:27.264874
279	3	Approved	\N	10	\N	Seeded assignment	\N
979	4	Approved	Beginner	2	Daily	Seeded assignment	2025-11-17 03:03:27.264874
373	11	Requested	Advanced	\N	\N	Seeded request	2025-11-05 07:25:27.264874
560	17	Requested	Intermediate	\N	Monthly	Seeded assignment	2025-11-23 01:29:27.264874
108	22	Approved	\N	\N	Daily	Seeded assignment	\N
838	18	Requested	\N	\N	Daily	Seeded request	2025-11-05 04:45:27.264874
988	17	Approved	\N	\N	Weekly	Seeded assignment	\N
643	22	Requested	\N	\N	Daily	Seeded assignment	\N
447	10	Requested	Advanced	3	Weekly	Seeded request	2025-12-02 22:50:27.264874
832	7	Requested	\N	6	Monthly	Seeded assignment	2025-11-29 07:30:27.264874
12	19	Requested	\N	8	Daily	Seeded assignment	2025-11-27 21:42:27.264874
218	11	Requested	\N	\N	Daily	Seeded assignment	2025-11-15 01:11:27.264874
440	1	Approved	Beginner	9	Weekly	Seeded assignment	\N
177	19	Requested	Intermediate	\N	Rarely	Seeded assignment	2025-11-12 00:15:27.264874
788	21	Approved	\N	\N	Weekly	Seeded assignment	2025-11-28 13:14:27.264874
294	8	Approved	\N	7	Rarely	Seeded assignment	\N
439	10	Approved	Advanced	1	\N	Seeded request	2025-11-17 04:46:27.264874
38	3	Requested	Expert	\N	\N	Seeded request	\N
128	3	Approved	Advanced	0	\N	Seeded assignment	2025-11-19 18:00:27.264874
228	13	Approved	Beginner	9	Monthly	Seeded request	2025-11-08 00:34:27.264874
809	25	Approved	Advanced	\N	Rarely	Seeded assignment	\N
847	20	Requested	\N	7	Daily	Seeded request	2025-11-05 20:38:27.264874
483	25	Approved	Intermediate	9	\N	Seeded request	2025-11-19 16:37:27.264874
679	16	Requested	Advanced	1	\N	Seeded request	\N
736	9	Approved	Intermediate	\N	Daily	Seeded request	2025-11-08 08:36:27.264874
843	19	Requested	\N	7	Weekly	Seeded assignment	\N
576	16	Approved	Intermediate	6	\N	Seeded assignment	\N
131	5	Approved	Expert	\N	Weekly	Seeded assignment	\N
170	3	Requested	Expert	\N	Daily	Seeded request	\N
745	18	Approved	\N	4	\N	Seeded request	\N
489	5	Requested	Advanced	\N	Monthly	Seeded request	2025-11-28 17:50:27.264874
437	20	Approved	Intermediate	9	\N	Seeded request	\N
785	11	Requested	Beginner	\N	\N	Seeded assignment	2025-11-09 04:05:27.264874
378	21	Requested	Advanced	8	Weekly	Seeded assignment	2025-11-23 20:19:27.264874
537	5	Requested	Advanced	0	Rarely	Seeded assignment	2025-11-10 13:28:27.264874
635	4	Approved	Expert	\N	Daily	Seeded assignment	2025-11-22 04:53:27.264874
85	9	Approved	\N	\N	Monthly	Seeded request	\N
184	9	Requested	\N	7	Weekly	Seeded assignment	\N
290	6	Requested	Expert	1	\N	Seeded assignment	\N
377	9	Requested	Intermediate	8	Daily	Seeded assignment	\N
685	25	Requested	Beginner	\N	Rarely	Seeded request	\N
398	16	Approved	Expert	\N	\N	Seeded request	\N
613	8	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-14 06:48:27.264874
725	3	Approved	Beginner	0	Monthly	Seeded assignment	2025-11-24 19:32:27.264874
136	12	Requested	\N	10	Daily	Seeded assignment	\N
405	18	Approved	\N	10	Weekly	Seeded assignment	\N
126	21	Requested	Beginner	3	\N	Seeded assignment	\N
511	21	Approved	\N	10	\N	Seeded assignment	2025-11-28 00:25:27.264874
662	13	Requested	\N	8	Monthly	Seeded request	2025-11-06 17:34:27.264874
753	7	Requested	Intermediate	\N	Rarely	Seeded assignment	2025-11-04 04:19:27.264874
960	6	Requested	\N	3	Monthly	Seeded request	2025-12-01 02:44:27.264874
443	9	Requested	Intermediate	6	\N	Seeded request	\N
64	19	Requested	\N	\N	Rarely	Seeded request	\N
791	6	Requested	\N	1	Weekly	Seeded assignment	\N
637	9	Approved	\N	8	Daily	Seeded request	\N
605	17	Requested	Intermediate	8	Daily	Seeded assignment	2025-11-15 01:48:27.264874
429	22	Requested	\N	3	\N	Seeded assignment	2025-11-05 07:28:27.264874
583	8	Requested	Expert	\N	Monthly	Seeded assignment	2025-11-07 05:54:27.264874
718	22	Approved	\N	\N	Rarely	Seeded assignment	\N
309	10	Approved	Intermediate	10	\N	Seeded assignment	\N
650	8	Approved	Expert	7	Daily	Seeded assignment	\N
23	6	Requested	\N	1	Monthly	Seeded request	\N
50	24	Requested	\N	2	\N	Seeded request	\N
823	5	Approved	Beginner	\N	Rarely	Seeded assignment	\N
445	23	Requested	Beginner	0	Rarely	Seeded assignment	\N
889	9	Approved	Beginner	7	Rarely	Seeded assignment	\N
565	22	Requested	\N	1	Weekly	Seeded request	\N
624	5	Requested	\N	5	\N	Seeded assignment	\N
224	24	Approved	Intermediate	6	Rarely	Seeded request	2025-11-04 01:47:27.264874
769	21	Approved	Beginner	5	Weekly	Seeded request	2025-11-15 10:25:27.264874
732	10	Requested	Expert	4	Monthly	Seeded request	\N
172	4	Requested	\N	10	Weekly	Seeded request	2025-11-19 22:18:27.264874
947	24	Requested	\N	\N	\N	Seeded request	\N
593	3	Requested	Beginner	5	Daily	Seeded assignment	2025-11-06 10:17:27.264874
446	25	Requested	Advanced	0	\N	Seeded assignment	\N
588	5	Requested	Intermediate	\N	Daily	Seeded request	\N
728	1	Approved	Expert	0	Monthly	Seeded assignment	2025-11-27 19:59:27.264874
71	5	Approved	\N	8	Weekly	Seeded assignment	2025-12-02 22:17:27.264874
488	21	Approved	Intermediate	1	Monthly	Seeded request	2025-11-07 09:58:27.264874
587	25	Requested	\N	\N	Daily	Seeded assignment	\N
175	17	Requested	Expert	6	Daily	Seeded request	\N
604	25	Approved	\N	9	Weekly	Seeded assignment	\N
638	16	Approved	\N	8	\N	Seeded assignment	\N
413	5	Requested	\N	10	\N	Seeded assignment	2025-11-23 01:27:27.264874
987	22	Requested	Beginner	0	Monthly	Seeded assignment	2025-11-24 19:58:27.264874
295	19	Requested	\N	3	Monthly	Seeded request	2025-11-27 12:05:27.264874
214	18	Requested	Beginner	\N	Weekly	Seeded assignment	\N
842	25	Requested	Beginner	6	Daily	Seeded assignment	\N
266	22	Approved	Beginner	\N	Rarely	Seeded assignment	\N
256	1	Approved	Beginner	\N	Daily	Seeded request	\N
961	25	Requested	Advanced	\N	Daily	Seeded assignment	\N
69	24	Requested	Beginner	10	Weekly	Seeded request	\N
26	20	Approved	Expert	\N	Daily	Seeded assignment	\N
458	5	Requested	\N	2	Rarely	Seeded assignment	2025-11-07 00:53:27.264874
518	18	Requested	\N	\N	\N	Seeded request	\N
581	3	Requested	\N	\N	\N	Seeded assignment	\N
2	13	Approved	Advanced	9	\N	Seeded assignment	\N
80	17	Approved	Intermediate	\N	\N	Seeded request	2025-11-18 01:00:27.264874
486	18	Approved	Expert	3	Monthly	Seeded assignment	\N
432	3	Approved	Intermediate	3	Rarely	Seeded assignment	2025-11-20 19:44:27.264874
796	13	Approved	\N	\N	Daily	Seeded request	\N
846	3	Requested	Expert	5	\N	Seeded assignment	\N
72	13	Approved	\N	\N	Rarely	Seeded assignment	2025-11-08 01:39:27.264874
939	10	Approved	Beginner	1	Monthly	Seeded assignment	2025-12-01 10:52:27.264874
330	18	Approved	Intermediate	3	Daily	Seeded request	\N
305	17	Approved	Advanced	4	Rarely	Seeded request	2025-11-22 06:06:27.264874
913	9	Requested	Intermediate	\N	Daily	Seeded request	2025-11-18 05:11:27.264874
312	17	Approved	\N	9	\N	Seeded request	\N
833	19	Approved	\N	\N	Monthly	Seeded assignment	\N
625	3	Approved	Intermediate	10	\N	Seeded assignment	2025-11-27 13:13:27.264874
847	12	Approved	Expert	\N	Daily	Seeded request	2025-11-21 16:52:27.264874
36	6	Requested	Expert	\N	Rarely	Seeded request	\N
254	3	Approved	Advanced	\N	Daily	Seeded request	\N
25	20	Approved	Beginner	3	\N	Seeded assignment	\N
20	18	Approved	Advanced	7	\N	Seeded assignment	\N
815	19	Requested	\N	\N	Rarely	Seeded assignment	\N
32	1	Approved	Expert	4	Daily	Seeded assignment	\N
941	22	Approved	\N	4	\N	Seeded request	\N
251	12	Approved	Intermediate	5	Monthly	Seeded request	2025-11-08 01:50:27.264874
239	19	Requested	Beginner	3	\N	Seeded request	\N
541	20	Requested	Expert	10	Rarely	Seeded assignment	\N
601	18	Requested	\N	\N	\N	Seeded assignment	\N
139	13	Approved	\N	\N	Daily	Seeded request	\N
453	23	Approved	\N	2	Monthly	Seeded assignment	\N
614	13	Approved	Beginner	7	Daily	Seeded assignment	\N
18	13	Approved	\N	5	Rarely	Seeded assignment	\N
681	18	Requested	\N	3	Daily	Seeded assignment	\N
829	8	Approved	\N	9	\N	Seeded assignment	\N
353	4	Approved	\N	1	Monthly	Seeded request	\N
616	23	Approved	Expert	8	Rarely	Seeded assignment	\N
736	1	Approved	\N	10	\N	Seeded assignment	\N
321	13	Requested	Intermediate	6	Daily	Seeded assignment	\N
611	8	Requested	Beginner	2	\N	Seeded assignment	\N
156	24	Requested	Advanced	1	\N	Seeded assignment	2025-11-19 17:41:27.264874
452	18	Requested	Advanced	\N	\N	Seeded request	2025-11-12 21:31:27.264874
818	3	Requested	Intermediate	\N	Rarely	Seeded request	\N
151	11	Requested	Beginner	\N	Monthly	Seeded request	2025-11-23 03:40:27.264874
937	3	Approved	Expert	8	\N	Seeded assignment	\N
647	18	Requested	Advanced	3	\N	Seeded request	2025-11-23 02:51:27.264874
185	25	Requested	Expert	8	\N	Seeded request	\N
864	7	Approved	Expert	3	\N	Seeded request	\N
921	11	Requested	Beginner	7	Daily	Seeded assignment	\N
949	13	Requested	\N	1	Weekly	Seeded request	2025-11-29 12:12:27.264874
253	11	Approved	Beginner	2	\N	Seeded assignment	2025-11-11 08:03:27.264874
505	13	Approved	Advanced	1	\N	Seeded assignment	\N
894	8	Requested	\N	2	\N	Seeded request	\N
635	3	Approved	Beginner	5	Monthly	Seeded assignment	\N
877	10	Approved	\N	10	Weekly	Seeded assignment	2025-11-03 18:15:27.264874
563	19	Requested	\N	\N	Monthly	Seeded assignment	2025-11-19 08:12:27.264874
786	20	Requested	Intermediate	\N	Weekly	Seeded assignment	\N
170	4	Approved	Beginner	9	Daily	Seeded request	\N
259	7	Requested	\N	8	\N	Seeded request	2025-11-14 07:45:27.264874
667	20	Approved	Intermediate	\N	\N	Seeded assignment	\N
959	10	Approved	\N	10	Weekly	Seeded assignment	2025-11-09 16:29:27.264874
105	8	Approved	Advanced	\N	Rarely	Seeded assignment	\N
699	17	Approved	\N	\N	Daily	Seeded assignment	\N
550	18	Approved	Expert	\N	\N	Seeded request	2025-11-25 05:56:27.264874
162	17	Requested	Intermediate	8	\N	Seeded assignment	\N
465	19	Requested	Advanced	\N	Monthly	Seeded assignment	2025-11-03 11:16:27.264874
171	6	Requested	Intermediate	\N	\N	Seeded assignment	\N
690	9	Approved	Beginner	6	Daily	Seeded assignment	\N
381	13	Approved	Intermediate	\N	\N	Seeded assignment	\N
38	4	Approved	Intermediate	0	\N	Seeded assignment	2025-11-16 00:58:27.264874
927	13	Requested	Beginner	\N	Monthly	Seeded request	\N
594	13	Approved	\N	2	\N	Seeded request	\N
245	7	Approved	\N	\N	Daily	Seeded assignment	2025-11-18 19:13:27.264874
847	5	Approved	Intermediate	0	\N	Seeded request	\N
982	8	Requested	\N	9	Weekly	Seeded assignment	\N
950	24	Requested	Expert	5	\N	Seeded assignment	2025-11-30 03:04:27.264874
390	21	Approved	Intermediate	7	\N	Seeded assignment	2025-11-16 10:40:27.264874
153	22	Approved	Intermediate	2	Monthly	Seeded assignment	\N
274	4	Requested	Expert	\N	\N	Seeded request	\N
905	7	Approved	\N	\N	Weekly	Seeded request	\N
469	7	Requested	Advanced	10	Daily	Seeded request	2025-11-16 16:02:27.264874
771	8	Requested	Intermediate	9	\N	Seeded assignment	2025-11-12 16:19:27.264874
507	3	Approved	Expert	\N	Weekly	Seeded assignment	2025-11-12 16:36:27.264874
763	11	Approved	\N	\N	\N	Seeded request	\N
627	16	Approved	Intermediate	10	Monthly	Seeded assignment	\N
207	10	Requested	\N	7	\N	Seeded assignment	\N
458	12	Approved	\N	6	\N	Seeded request	\N
131	20	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-08 15:38:27.264874
752	11	Approved	\N	6	Rarely	Seeded request	\N
328	6	Approved	\N	10	Weekly	Seeded assignment	\N
418	10	Approved	Expert	10	\N	Seeded assignment	\N
413	12	Approved	Expert	0	Daily	Seeded assignment	\N
537	20	Approved	Intermediate	\N	Rarely	Seeded assignment	2025-11-28 04:54:27.264874
696	16	Approved	\N	\N	Rarely	Seeded assignment	\N
198	12	Requested	Beginner	2	\N	Seeded request	\N
137	19	Approved	Intermediate	1	Rarely	Seeded assignment	2025-11-10 08:56:27.264874
252	20	Approved	Expert	\N	\N	Seeded assignment	\N
272	6	Approved	Expert	8	Weekly	Seeded assignment	\N
463	10	Requested	\N	5	Rarely	Seeded request	\N
162	21	Approved	Beginner	\N	Daily	Seeded assignment	\N
590	1	Approved	\N	\N	\N	Seeded assignment	2025-11-03 10:30:27.264874
853	11	Approved	Intermediate	6	\N	Seeded assignment	\N
591	17	Approved	\N	\N	Monthly	Seeded assignment	\N
745	19	Approved	Expert	3	Monthly	Seeded request	2025-11-13 04:09:27.264874
588	12	Approved	Advanced	8	Weekly	Seeded request	\N
521	17	Approved	Expert	1	Monthly	Seeded assignment	2025-11-13 04:29:27.264874
231	6	Approved	Expert	\N	Weekly	Seeded assignment	\N
459	4	Approved	Beginner	2	\N	Seeded assignment	2025-11-22 05:39:27.264874
268	13	Approved	\N	3	Weekly	Seeded assignment	\N
741	16	Requested	Advanced	\N	Rarely	Seeded assignment	\N
715	17	Approved	Beginner	\N	\N	Seeded assignment	2025-11-13 07:05:27.264874
234	18	Approved	Expert	\N	Rarely	Seeded request	\N
362	21	Approved	Expert	9	\N	Seeded request	\N
674	11	Requested	Beginner	\N	Daily	Seeded assignment	\N
56	22	Approved	Expert	\N	Rarely	Seeded assignment	2025-11-06 21:21:27.264874
118	6	Requested	\N	\N	\N	Seeded assignment	\N
361	16	Requested	\N	1	Daily	Seeded request	\N
912	7	Approved	\N	10	\N	Seeded assignment	\N
956	11	Approved	\N	6	\N	Seeded request	\N
543	3	Approved	\N	\N	Daily	Seeded request	2025-11-19 00:06:27.264874
644	20	Approved	\N	5	Rarely	Seeded assignment	\N
599	5	Requested	Beginner	2	Rarely	Seeded assignment	\N
726	23	Approved	\N	\N	\N	Seeded request	2025-11-11 03:35:27.264874
282	12	Approved	\N	8	Daily	Seeded assignment	\N
869	3	Approved	\N	4	Rarely	Seeded request	\N
63	6	Requested	\N	2	\N	Seeded request	\N
296	12	Approved	Beginner	0	\N	Seeded assignment	\N
915	9	Approved	Expert	\N	Daily	Seeded assignment	\N
524	20	Approved	Expert	3	Monthly	Seeded assignment	\N
280	22	Approved	Advanced	\N	\N	Seeded request	2025-11-25 06:05:27.264874
876	21	Requested	Advanced	\N	Monthly	Seeded assignment	\N
90	10	Approved	Intermediate	3	Weekly	Seeded assignment	\N
372	7	Approved	Intermediate	\N	Daily	Seeded assignment	\N
516	17	Requested	Advanced	\N	\N	Seeded assignment	2025-11-20 05:40:27.264874
308	6	Approved	\N	5	\N	Seeded assignment	2025-12-02 17:35:27.264874
659	8	Requested	Expert	8	\N	Seeded request	\N
59	10	Requested	\N	\N	Weekly	Seeded assignment	2025-11-17 14:56:27.264874
473	1	Approved	Advanced	\N	\N	Seeded assignment	2025-11-23 02:12:27.264874
80	21	Approved	Advanced	4	Monthly	Seeded request	2025-11-29 07:21:27.264874
408	18	Requested	\N	1	\N	Seeded request	\N
566	9	Approved	\N	\N	Rarely	Seeded assignment	2025-11-10 06:40:27.264874
719	3	Approved	\N	7	Daily	Seeded assignment	\N
200	23	Requested	Expert	8	Daily	Seeded assignment	\N
210	8	Requested	\N	\N	Rarely	Seeded request	\N
689	1	Requested	Advanced	3	Weekly	Seeded request	2025-11-16 16:36:27.264874
851	4	Approved	Intermediate	7	\N	Seeded request	\N
933	6	Requested	Beginner	8	Daily	Seeded assignment	2025-11-29 14:09:27.264874
84	17	Approved	\N	5	Weekly	Seeded request	\N
683	21	Approved	Advanced	\N	\N	Seeded request	\N
336	25	Approved	Expert	2	Rarely	Seeded request	\N
355	16	Approved	Intermediate	\N	Monthly	Seeded assignment	2025-11-13 10:26:27.264874
182	16	Approved	Expert	\N	Weekly	Seeded assignment	\N
783	6	Approved	Expert	5	Daily	Seeded assignment	2025-11-07 20:42:27.264874
556	9	Requested	Beginner	7	\N	Seeded request	\N
1	7	Requested	Expert	\N	\N	Seeded request	2025-11-10 13:07:27.264874
369	25	Approved	Intermediate	8	Weekly	Seeded assignment	\N
186	11	Requested	\N	8	Daily	Seeded assignment	2025-11-10 03:47:27.264874
837	3	Approved	\N	5	Daily	Seeded assignment	\N
357	12	Approved	Advanced	2	\N	Seeded assignment	2025-11-11 09:22:27.264874
737	1	Approved	\N	\N	Monthly	Seeded request	\N
878	8	Requested	\N	\N	Daily	Seeded assignment	2025-11-19 06:44:27.264874
35	6	Requested	\N	1	Rarely	Seeded assignment	\N
299	24	Approved	Advanced	3	Monthly	Seeded assignment	2025-11-30 12:35:27.264874
484	16	Requested	Expert	\N	Daily	Seeded request	2025-11-14 06:33:27.264874
602	6	Approved	Intermediate	4	\N	Seeded request	\N
577	19	Requested	\N	8	\N	Seeded assignment	2025-11-07 14:55:27.264874
378	17	Requested	Beginner	\N	\N	Seeded request	\N
471	18	Requested	Intermediate	9	\N	Seeded assignment	\N
459	3	Approved	\N	\N	\N	Seeded request	2025-11-22 07:05:27.264874
17	12	Approved	Expert	0	Monthly	Seeded request	\N
550	19	Requested	Intermediate	\N	Monthly	Seeded assignment	\N
307	5	Approved	\N	\N	\N	Seeded request	2025-11-07 09:51:27.264874
284	18	Approved	\N	\N	\N	Seeded assignment	\N
655	20	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-20 21:42:27.264874
787	6	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
861	12	Requested	Beginner	5	Monthly	Seeded assignment	\N
948	7	Requested	Advanced	0	\N	Seeded request	2025-11-11 21:39:27.264874
821	24	Approved	Intermediate	\N	Weekly	Seeded assignment	2025-11-22 12:42:27.264874
970	9	Approved	Advanced	\N	Rarely	Seeded assignment	\N
442	18	Requested	Beginner	7	\N	Seeded request	\N
200	7	Approved	Advanced	5	Weekly	Seeded assignment	\N
287	1	Approved	Beginner	4	\N	Seeded assignment	2025-11-05 18:12:27.264874
513	10	Approved	\N	8	\N	Seeded assignment	\N
873	6	Approved	\N	2	\N	Seeded request	\N
449	5	Approved	Beginner	\N	Rarely	Seeded assignment	\N
485	16	Approved	Expert	\N	Daily	Seeded request	2025-11-20 01:14:27.264874
939	24	Requested	\N	0	\N	Seeded assignment	2025-11-27 22:22:27.264874
127	24	Approved	Advanced	9	Weekly	Seeded request	\N
150	8	Approved	Beginner	\N	Rarely	Seeded assignment	\N
943	8	Approved	Expert	\N	\N	Seeded assignment	2025-11-12 20:48:27.264874
21	22	Requested	Advanced	\N	\N	Seeded request	2025-11-12 12:10:27.264874
344	6	Approved	\N	2	\N	Seeded request	\N
666	23	Requested	\N	9	Weekly	Seeded assignment	\N
282	20	Approved	Advanced	9	Monthly	Seeded assignment	2025-11-19 08:19:27.264874
368	7	Approved	Advanced	5	\N	Seeded request	\N
776	6	Requested	Expert	8	\N	Seeded assignment	2025-11-18 17:50:27.264874
126	17	Requested	Intermediate	6	Rarely	Seeded request	2025-11-17 07:21:27.264874
815	18	Approved	\N	\N	\N	Seeded assignment	\N
597	6	Approved	Advanced	\N	Weekly	Seeded request	\N
552	25	Approved	Intermediate	3	Daily	Seeded assignment	\N
800	1	Approved	Intermediate	6	\N	Seeded assignment	2025-11-28 12:31:27.264874
20	19	Approved	\N	9	Monthly	Seeded request	\N
245	23	Requested	\N	\N	Daily	Seeded request	\N
631	3	Approved	Advanced	\N	Daily	Seeded assignment	\N
156	10	Approved	Beginner	6	Weekly	Seeded assignment	\N
189	22	Requested	Beginner	8	Weekly	Seeded request	\N
169	6	Requested	Advanced	3	Rarely	Seeded assignment	\N
486	19	Requested	\N	3	Rarely	Seeded assignment	\N
812	11	Requested	Expert	\N	\N	Seeded assignment	\N
886	9	Approved	\N	7	\N	Seeded assignment	\N
518	19	Requested	Intermediate	3	Monthly	Seeded assignment	2025-11-05 19:14:27.264874
731	6	Approved	Beginner	0	\N	Seeded request	2025-12-03 04:15:27.264874
727	9	Approved	Intermediate	2	\N	Seeded assignment	2025-11-28 17:17:27.264874
915	1	Approved	\N	\N	Rarely	Seeded assignment	2025-11-22 04:08:27.264874
240	8	Approved	Expert	\N	Daily	Seeded assignment	2025-12-02 21:19:27.264874
11	18	Requested	\N	\N	\N	Seeded assignment	\N
980	11	Requested	Beginner	7	Daily	Seeded assignment	\N
71	20	Approved	Beginner	1	\N	Seeded assignment	\N
404	1	Approved	Expert	8	Weekly	Seeded assignment	2025-11-25 23:48:27.264874
645	6	Requested	Intermediate	3	Rarely	Seeded request	\N
83	3	Approved	\N	1	Monthly	Seeded request	\N
194	10	Requested	Advanced	1	\N	Seeded assignment	\N
475	4	Approved	\N	\N	Weekly	Seeded request	\N
515	22	Requested	\N	2	Weekly	Seeded request	2025-11-05 23:44:27.264874
338	25	Requested	\N	3	\N	Seeded assignment	2025-12-02 23:47:27.264874
612	8	Approved	\N	\N	Daily	Seeded assignment	2025-11-03 13:47:27.264874
925	8	Requested	Expert	3	\N	Seeded assignment	\N
271	25	Approved	Advanced	3	Rarely	Seeded request	\N
849	17	Requested	Advanced	2	Daily	Seeded assignment	\N
538	8	Approved	Expert	0	Weekly	Seeded request	\N
764	17	Approved	Beginner	6	\N	Seeded assignment	\N
384	19	Requested	Beginner	6	\N	Seeded request	2025-11-16 03:58:27.264874
370	24	Approved	Advanced	7	Monthly	Seeded request	\N
633	11	Approved	Advanced	5	\N	Seeded request	\N
131	12	Approved	Expert	4	Rarely	Seeded assignment	2025-11-17 12:34:27.264874
458	20	Approved	Advanced	10	Weekly	Seeded request	\N
700	19	Approved	Intermediate	\N	\N	Seeded request	2025-11-13 05:19:27.264874
410	7	Approved	\N	1	\N	Seeded assignment	\N
882	18	Requested	Beginner	9	Daily	Seeded assignment	\N
168	13	Approved	Intermediate	4	Daily	Seeded assignment	2025-11-09 23:56:27.264874
347	7	Requested	\N	\N	Weekly	Seeded request	\N
477	17	Requested	Beginner	8	Daily	Seeded assignment	2025-12-02 07:20:27.264874
499	16	Approved	Expert	1	Weekly	Seeded assignment	\N
819	9	Approved	\N	\N	\N	Seeded request	2025-11-07 16:38:27.264874
45	23	Requested	Intermediate	9	Weekly	Seeded request	\N
25	5	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-17 04:19:27.264874
689	9	Requested	Beginner	0	Rarely	Seeded request	\N
893	9	Approved	Expert	6	Rarely	Seeded request	\N
217	24	Approved	Expert	\N	\N	Seeded request	\N
654	13	Requested	\N	5	\N	Seeded assignment	\N
163	9	Requested	Expert	\N	\N	Seeded assignment	2025-11-04 21:17:27.264874
744	8	Approved	Beginner	8	\N	Seeded assignment	\N
576	13	Approved	Expert	0	Rarely	Seeded assignment	2025-11-05 10:58:27.264874
104	9	Approved	Beginner	2	Daily	Seeded request	2025-11-27 00:22:27.264874
857	25	Approved	Beginner	6	Rarely	Seeded assignment	\N
433	18	Approved	\N	10	Monthly	Seeded assignment	2025-11-08 16:55:27.264874
142	22	Approved	Advanced	5	Daily	Seeded assignment	\N
333	11	Requested	Advanced	\N	Monthly	Seeded assignment	2025-11-15 14:04:27.264874
834	4	Requested	\N	\N	Rarely	Seeded assignment	\N
65	5	Approved	\N	9	\N	Seeded assignment	\N
354	7	Approved	\N	\N	\N	Seeded request	2025-11-15 10:18:27.264874
133	19	Requested	Expert	\N	\N	Seeded assignment	2025-11-08 10:54:27.264874
108	5	Requested	Intermediate	\N	\N	Seeded request	2025-11-19 18:31:27.264874
303	12	Approved	Advanced	7	Monthly	Seeded request	2025-11-12 20:43:27.264874
493	13	Approved	Expert	9	Monthly	Seeded request	\N
228	16	Requested	\N	\N	Rarely	Seeded assignment	\N
135	16	Requested	Advanced	10	\N	Seeded assignment	2025-11-03 15:11:27.264874
33	1	Requested	\N	1	Weekly	Seeded assignment	\N
357	22	Approved	\N	6	\N	Seeded assignment	2025-11-11 01:34:27.264874
844	23	Approved	Intermediate	\N	Weekly	Seeded assignment	2025-11-29 15:25:27.264874
107	13	Requested	\N	6	Monthly	Seeded request	2025-11-18 15:06:27.264874
179	8	Requested	\N	7	\N	Seeded request	2025-11-30 01:10:27.264874
755	19	Requested	Advanced	0	Rarely	Seeded request	2025-11-10 15:17:27.264874
492	19	Requested	Advanced	1	\N	Seeded request	\N
820	13	Requested	Expert	1	\N	Seeded assignment	\N
504	1	Approved	Expert	\N	Rarely	Seeded assignment	2025-11-27 16:43:27.264874
551	8	Approved	\N	0	\N	Seeded assignment	\N
12	3	Approved	Expert	2	\N	Seeded assignment	\N
419	20	Approved	\N	\N	\N	Seeded assignment	\N
534	23	Approved	\N	\N	Monthly	Seeded request	2025-11-21 02:33:27.264874
644	22	Approved	\N	0	Weekly	Seeded assignment	\N
147	21	Approved	Advanced	\N	Monthly	Seeded assignment	\N
894	10	Requested	\N	\N	\N	Seeded assignment	\N
314	20	Approved	\N	9	Daily	Seeded assignment	\N
547	11	Approved	Expert	\N	\N	Seeded assignment	\N
805	4	Requested	\N	\N	\N	Seeded assignment	2025-11-16 15:01:27.264874
909	10	Requested	\N	4	Weekly	Seeded assignment	2025-11-07 13:36:27.264874
269	23	Approved	Expert	9	\N	Seeded assignment	2025-11-13 15:42:27.264874
587	6	Approved	Expert	\N	\N	Seeded request	\N
914	22	Approved	\N	\N	\N	Seeded request	2025-11-14 17:24:27.264874
421	19	Requested	\N	9	Daily	Seeded request	\N
23	25	Approved	\N	\N	Rarely	Seeded assignment	2025-11-07 21:30:27.264874
462	18	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-17 09:52:27.264874
598	21	Requested	\N	8	\N	Seeded assignment	\N
884	21	Approved	Beginner	1	Rarely	Seeded assignment	2025-11-30 03:10:27.264874
424	3	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-12 17:54:27.264874
281	12	Approved	Intermediate	10	Monthly	Seeded assignment	\N
408	3	Approved	Advanced	7	Weekly	Seeded assignment	\N
816	22	Approved	\N	\N	Monthly	Seeded assignment	2025-11-04 10:17:27.264874
442	4	Requested	Expert	\N	Rarely	Seeded assignment	\N
176	21	Approved	\N	8	Rarely	Seeded request	2025-11-22 01:57:27.264874
904	25	Approved	Beginner	8	\N	Seeded assignment	2025-12-01 21:21:27.264874
694	5	Approved	Expert	\N	\N	Seeded request	\N
891	20	Requested	\N	9	Rarely	Seeded assignment	2025-12-01 15:18:27.264874
774	1	Requested	Expert	5	\N	Seeded request	2025-11-26 02:17:27.264874
737	11	Requested	Expert	1	Weekly	Seeded assignment	\N
507	18	Requested	Beginner	5	Rarely	Seeded request	2025-11-27 18:18:27.264874
734	7	Requested	\N	4	\N	Seeded request	\N
729	20	Approved	\N	7	Daily	Seeded assignment	2025-11-17 15:56:27.264874
712	12	Requested	\N	7	\N	Seeded request	2025-11-13 17:27:27.264874
782	11	Requested	Beginner	4	Weekly	Seeded assignment	\N
867	24	Approved	\N	4	Rarely	Seeded request	\N
64	3	Approved	\N	\N	Rarely	Seeded request	2025-11-14 09:19:27.264874
299	8	Approved	Intermediate	\N	Daily	Seeded request	\N
640	16	Approved	Expert	6	Weekly	Seeded assignment	2025-11-26 09:32:27.264874
160	16	Requested	Expert	6	Daily	Seeded assignment	\N
431	21	Requested	Beginner	1	\N	Seeded assignment	\N
487	6	Approved	\N	2	Rarely	Seeded request	\N
56	20	Requested	Intermediate	8	Weekly	Seeded request	\N
523	1	Requested	Intermediate	8	Daily	Seeded assignment	\N
561	17	Approved	\N	\N	\N	Seeded assignment	\N
229	17	Requested	Advanced	1	\N	Seeded assignment	\N
896	5	Approved	Advanced	8	Daily	Seeded assignment	\N
839	1	Approved	Intermediate	6	Daily	Seeded assignment	2025-11-11 10:07:27.264874
974	22	Requested	Advanced	1	Weekly	Seeded assignment	2025-11-20 00:26:27.264874
77	20	Requested	\N	2	\N	Seeded request	2025-11-16 01:02:27.264874
125	20	Approved	Expert	7	\N	Seeded request	\N
906	17	Approved	Intermediate	5	Rarely	Seeded assignment	2025-11-22 03:06:27.264874
926	24	Approved	\N	\N	Weekly	Seeded request	\N
761	23	Approved	Beginner	\N	Weekly	Seeded assignment	\N
211	20	Approved	Beginner	\N	\N	Seeded request	\N
193	9	Approved	Expert	0	Daily	Seeded assignment	\N
563	4	Requested	Intermediate	7	Weekly	Seeded assignment	\N
879	12	Approved	Expert	9	Rarely	Seeded assignment	\N
978	10	Requested	\N	\N	Monthly	Seeded assignment	\N
385	7	Requested	Advanced	\N	Monthly	Seeded request	2025-11-06 18:37:27.264874
441	7	Approved	Advanced	0	Daily	Seeded assignment	\N
350	23	Requested	Expert	7	Weekly	Seeded request	\N
439	8	Requested	\N	4	Weekly	Seeded assignment	\N
740	21	Requested	\N	2	Daily	Seeded request	\N
859	24	Approved	Expert	\N	Rarely	Seeded assignment	\N
962	21	Approved	Intermediate	5	Monthly	Seeded assignment	2025-11-12 17:25:27.264874
145	1	Requested	Intermediate	\N	Weekly	Seeded request	\N
144	21	Requested	\N	5	Monthly	Seeded request	\N
615	21	Approved	\N	\N	\N	Seeded assignment	2025-11-17 05:37:27.264874
337	11	Requested	Expert	3	Monthly	Seeded assignment	\N
4	10	Approved	\N	\N	\N	Seeded assignment	\N
495	25	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
432	19	Approved	Expert	5	Weekly	Seeded assignment	2025-11-22 12:06:27.264874
212	21	Approved	Beginner	5	\N	Seeded request	2025-11-10 17:32:27.264874
614	16	Requested	Advanced	4	\N	Seeded assignment	2025-11-27 03:23:27.264874
77	12	Approved	\N	0	\N	Seeded assignment	\N
781	11	Requested	\N	4	Weekly	Seeded request	\N
476	24	Approved	Expert	\N	Daily	Seeded assignment	\N
438	8	Requested	Advanced	6	Weekly	Seeded assignment	2025-11-17 18:26:27.264874
14	24	Approved	\N	\N	Rarely	Seeded assignment	\N
684	16	Requested	Beginner	9	Daily	Seeded request	\N
687	18	Approved	Advanced	\N	\N	Seeded assignment	\N
466	16	Approved	Expert	\N	\N	Seeded assignment	\N
12	4	Approved	\N	8	Rarely	Seeded request	\N
819	11	Approved	\N	1	Daily	Seeded request	2025-11-28 14:15:27.264874
658	7	Requested	\N	\N	Rarely	Seeded assignment	2025-11-05 03:01:27.264874
928	5	Requested	\N	0	Daily	Seeded request	\N
567	7	Approved	\N	5	Weekly	Seeded assignment	2025-11-24 16:53:27.264874
766	17	Approved	\N	\N	Rarely	Seeded request	\N
813	11	Requested	\N	5	\N	Seeded assignment	\N
186	1	Approved	Intermediate	\N	Daily	Seeded assignment	2025-11-21 14:05:27.264874
568	10	Requested	\N	9	\N	Seeded assignment	2025-11-27 20:16:27.264874
661	19	Requested	Beginner	10	\N	Seeded assignment	2025-11-20 21:39:27.264874
891	12	Approved	\N	6	Weekly	Seeded request	2025-11-23 13:30:27.264874
324	4	Approved	Advanced	\N	\N	Seeded assignment	\N
749	21	Requested	Advanced	6	\N	Seeded request	\N
313	6	Approved	\N	\N	Daily	Seeded assignment	\N
210	24	Requested	Advanced	\N	\N	Seeded assignment	\N
508	3	Approved	\N	1	Weekly	Seeded assignment	2025-11-26 23:07:27.264874
494	5	Requested	\N	4	\N	Seeded assignment	2025-12-01 20:00:27.264874
557	23	Requested	Advanced	6	Daily	Seeded assignment	\N
633	9	Requested	\N	\N	\N	Seeded assignment	2025-11-06 09:54:27.264874
763	1	Requested	Beginner	1	Weekly	Seeded request	\N
648	10	Approved	\N	2	\N	Seeded assignment	2025-11-03 21:30:27.264874
791	25	Requested	Advanced	\N	Monthly	Seeded assignment	\N
78	13	Requested	\N	\N	Daily	Seeded request	\N
346	18	Requested	Expert	4	\N	Seeded request	\N
929	25	Requested	Intermediate	\N	Rarely	Seeded request	\N
315	4	Approved	\N	0	\N	Seeded assignment	2025-11-19 00:22:27.264874
739	5	Approved	\N	\N	Weekly	Seeded request	2025-12-01 17:38:27.264874
704	13	Approved	\N	1	\N	Seeded request	\N
803	5	Requested	Beginner	\N	Monthly	Seeded request	\N
232	5	Approved	Expert	\N	Weekly	Seeded request	\N
222	17	Approved	Expert	\N	Weekly	Seeded request	\N
284	3	Approved	Intermediate	2	Rarely	Seeded assignment	\N
570	20	Requested	Beginner	\N	\N	Seeded assignment	2025-11-28 20:21:27.264874
692	5	Requested	Beginner	9	\N	Seeded assignment	2025-11-12 19:11:27.264874
242	10	Approved	\N	\N	\N	Seeded assignment	2025-11-25 06:28:27.264874
688	7	Requested	Advanced	8	\N	Seeded assignment	\N
938	18	Requested	Beginner	\N	\N	Seeded assignment	2025-11-13 13:56:27.264874
793	25	Approved	\N	8	Weekly	Seeded assignment	2025-11-16 02:19:27.264874
190	10	Approved	Intermediate	1	\N	Seeded assignment	2025-11-20 04:27:27.264874
777	16	Requested	Beginner	\N	\N	Seeded assignment	2025-11-12 13:36:27.264874
582	16	Requested	\N	6	Monthly	Seeded assignment	2025-11-27 23:44:27.264874
177	4	Requested	\N	\N	Daily	Seeded assignment	\N
246	23	Approved	Expert	9	\N	Seeded assignment	2025-11-13 01:29:27.264874
419	12	Approved	\N	\N	\N	Seeded assignment	2025-11-14 10:10:27.264874
835	7	Approved	Beginner	\N	\N	Seeded assignment	2025-11-23 10:00:27.264874
72	16	Approved	\N	\N	Monthly	Seeded assignment	2025-11-30 04:27:27.264874
941	5	Requested	Advanced	4	Weekly	Seeded assignment	2025-11-30 18:12:27.264874
636	12	Requested	Beginner	\N	Rarely	Seeded request	\N
174	17	Approved	\N	\N	Daily	Seeded request	\N
167	22	Approved	\N	\N	\N	Seeded request	\N
595	12	Requested	Beginner	6	Rarely	Seeded assignment	\N
86	25	Approved	Expert	5	Daily	Seeded assignment	\N
559	9	Approved	\N	\N	Weekly	Seeded request	2025-11-11 16:57:27.264874
655	22	Approved	Advanced	3	Daily	Seeded request	2025-11-14 17:57:27.264874
862	23	Approved	\N	8	Monthly	Seeded request	2025-11-14 08:30:27.264874
818	19	Requested	Advanced	6	Weekly	Seeded request	\N
447	8	Approved	\N	9	Weekly	Seeded assignment	2025-11-16 00:45:27.264874
885	11	Approved	Advanced	0	Daily	Seeded assignment	\N
522	24	Requested	\N	2	Daily	Seeded assignment	\N
920	24	Approved	Intermediate	7	\N	Seeded assignment	2025-11-04 13:37:27.264874
57	3	Requested	\N	10	Monthly	Seeded assignment	2025-11-28 15:31:27.264874
442	3	Approved	\N	\N	Weekly	Seeded assignment	\N
664	16	Requested	\N	\N	\N	Seeded request	\N
908	10	Requested	\N	\N	\N	Seeded request	2025-11-28 05:36:27.264874
114	7	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-18 17:19:27.264874
436	17	Approved	\N	6	Monthly	Seeded request	\N
546	11	Requested	\N	\N	\N	Seeded assignment	2025-11-20 14:13:27.264874
750	7	Approved	Advanced	\N	Rarely	Seeded assignment	2025-11-16 09:44:27.264874
611	24	Approved	\N	4	\N	Seeded request	\N
776	25	Requested	\N	10	\N	Seeded request	\N
641	7	Approved	Advanced	10	Rarely	Seeded request	2025-11-08 16:16:27.264874
756	1	Approved	\N	0	Weekly	Seeded request	2025-11-16 01:41:27.264874
156	8	Requested	Beginner	8	Daily	Seeded request	2025-11-11 01:44:27.264874
253	1	Approved	\N	5	\N	Seeded request	\N
300	12	Approved	Intermediate	9	\N	Seeded request	2025-11-28 23:33:27.264874
230	9	Approved	Beginner	\N	Weekly	Seeded request	\N
249	8	Requested	Expert	\N	\N	Seeded request	2025-11-24 11:47:27.264874
361	13	Approved	\N	8	\N	Seeded request	\N
240	10	Approved	\N	\N	Rarely	Seeded assignment	\N
565	12	Requested	Intermediate	8	Daily	Seeded request	\N
829	24	Requested	Advanced	1	Monthly	Seeded assignment	\N
872	1	Approved	Beginner	8	\N	Seeded assignment	2025-11-04 05:32:27.264874
919	13	Approved	\N	1	Daily	Seeded request	\N
902	25	Approved	Advanced	\N	Daily	Seeded assignment	\N
217	10	Approved	\N	\N	\N	Seeded assignment	\N
855	23	Approved	\N	8	Weekly	Seeded assignment	\N
29	6	Requested	Advanced	\N	Daily	Seeded assignment	2025-11-27 07:11:27.264874
928	12	Approved	Beginner	\N	Monthly	Seeded assignment	\N
612	10	Approved	\N	\N	Daily	Seeded request	\N
443	11	Approved	Beginner	3	Daily	Seeded request	\N
538	10	Approved	Expert	8	Rarely	Seeded assignment	\N
758	11	Requested	Advanced	\N	Daily	Seeded assignment	2025-11-21 02:51:27.264874
106	4	Requested	\N	\N	Rarely	Seeded assignment	\N
986	7	Approved	Intermediate	4	\N	Seeded assignment	\N
875	11	Requested	Intermediate	6	\N	Seeded assignment	\N
822	20	Approved	Intermediate	10	Weekly	Seeded request	\N
125	5	Approved	Intermediate	8	Monthly	Seeded request	2025-11-16 04:46:27.264874
681	4	Requested	Beginner	1	Monthly	Seeded assignment	\N
592	17	Approved	Intermediate	4	Daily	Seeded request	\N
15	5	Requested	Intermediate	6	Monthly	Seeded assignment	2025-11-30 19:08:27.264874
286	7	Approved	\N	3	\N	Seeded assignment	\N
721	8	Approved	Expert	\N	\N	Seeded assignment	\N
93	9	Approved	Expert	9	Monthly	Seeded request	\N
725	18	Approved	\N	4	Monthly	Seeded assignment	\N
195	23	Approved	Expert	2	\N	Seeded assignment	\N
647	4	Approved	Advanced	7	Daily	Seeded assignment	2025-11-10 20:18:27.264874
427	11	Approved	Intermediate	\N	\N	Seeded assignment	\N
894	24	Approved	Advanced	3	Monthly	Seeded request	2025-11-22 23:51:27.264874
865	12	Requested	Expert	9	Rarely	Seeded request	\N
757	17	Approved	\N	\N	Rarely	Seeded assignment	\N
475	19	Approved	Advanced	8	Monthly	Seeded request	\N
352	8	Requested	\N	1	\N	Seeded request	2025-11-17 04:13:27.264874
883	3	Approved	Expert	\N	Daily	Seeded assignment	2025-11-13 20:53:27.264874
703	8	Approved	Beginner	1	\N	Seeded assignment	\N
802	1	Approved	\N	\N	Monthly	Seeded assignment	\N
887	1	Requested	\N	1	\N	Seeded assignment	2025-11-23 16:07:27.264874
867	10	Approved	\N	6	Weekly	Seeded assignment	\N
213	9	Approved	\N	5	Monthly	Seeded request	\N
486	4	Requested	Advanced	\N	Rarely	Seeded request	\N
643	20	Approved	\N	8	Daily	Seeded assignment	2025-11-04 15:04:27.264874
751	23	Requested	\N	9	Rarely	Seeded assignment	\N
660	8	Approved	Advanced	\N	Weekly	Seeded request	\N
828	23	Approved	\N	1	Rarely	Seeded assignment	2025-11-27 14:26:27.264874
108	20	Requested	Advanced	\N	Weekly	Seeded request	\N
852	16	Requested	Beginner	5	Rarely	Seeded request	\N
962	17	Approved	Expert	0	\N	Seeded assignment	\N
224	8	Approved	Expert	6	\N	Seeded request	\N
399	16	Approved	\N	2	Daily	Seeded assignment	2025-11-24 16:43:27.264874
708	7	Approved	\N	9	\N	Seeded request	2025-11-30 07:15:27.264874
50	8	Requested	Intermediate	10	\N	Seeded assignment	\N
251	22	Approved	\N	\N	Rarely	Seeded assignment	\N
837	19	Approved	\N	\N	\N	Seeded assignment	2025-11-14 19:20:27.264874
450	6	Approved	\N	6	\N	Seeded assignment	2025-11-10 05:47:27.264874
513	8	Requested	\N	10	\N	Seeded assignment	\N
492	18	Approved	\N	\N	Weekly	Seeded request	2025-11-26 19:28:27.264874
586	8	Requested	\N	\N	Monthly	Seeded assignment	2025-11-07 11:38:27.264874
978	24	Approved	Expert	\N	Monthly	Seeded assignment	2025-12-02 16:07:27.264874
572	24	Approved	Beginner	\N	Monthly	Seeded assignment	\N
549	16	Approved	\N	\N	Weekly	Seeded assignment	\N
838	3	Requested	\N	\N	Weekly	Seeded request	2025-11-25 13:17:27.264874
926	10	Approved	\N	\N	\N	Seeded assignment	\N
804	12	Approved	\N	5	Rarely	Seeded request	\N
276	22	Approved	Beginner	8	Weekly	Seeded assignment	\N
279	18	Requested	\N	5	Daily	Seeded request	\N
645	25	Requested	Intermediate	6	Rarely	Seeded assignment	2025-11-30 03:26:27.264874
133	18	Approved	\N	\N	Monthly	Seeded request	\N
739	12	Approved	Beginner	8	\N	Seeded assignment	2025-11-23 03:22:27.264874
700	4	Approved	Advanced	\N	Monthly	Seeded assignment	2025-12-02 17:42:27.264874
130	17	Requested	\N	\N	Daily	Seeded assignment	2025-11-27 09:06:27.264874
320	13	Requested	Beginner	\N	\N	Seeded assignment	\N
273	6	Approved	\N	2	Rarely	Seeded assignment	\N
433	19	Approved	Advanced	8	Rarely	Seeded request	2025-11-06 04:47:27.264874
529	8	Approved	Expert	2	Rarely	Seeded request	\N
770	19	Approved	\N	8	\N	Seeded assignment	\N
169	25	Requested	Advanced	\N	\N	Seeded request	\N
247	21	Approved	Advanced	9	\N	Seeded request	\N
87	25	Approved	Advanced	\N	\N	Seeded request	2025-11-09 17:44:27.264874
772	17	Requested	Advanced	\N	Monthly	Seeded request	\N
801	1	Approved	Expert	10	Monthly	Seeded request	2025-12-01 00:41:27.264874
124	21	Approved	\N	\N	\N	Seeded assignment	\N
935	18	Approved	\N	\N	Weekly	Seeded assignment	\N
786	22	Requested	\N	10	Weekly	Seeded assignment	2025-11-09 11:19:27.264874
281	5	Approved	Expert	\N	Rarely	Seeded assignment	\N
367	11	Requested	Expert	3	\N	Seeded request	\N
119	9	Requested	\N	\N	Weekly	Seeded assignment	\N
334	6	Approved	\N	9	Rarely	Seeded assignment	2025-12-01 13:02:27.264874
870	8	Approved	Beginner	7	Monthly	Seeded assignment	\N
401	5	Approved	\N	\N	Weekly	Seeded assignment	2025-11-23 21:04:27.264874
570	5	Approved	Intermediate	0	\N	Seeded assignment	\N
229	21	Requested	\N	4	Rarely	Seeded request	\N
872	9	Approved	\N	\N	\N	Seeded assignment	\N
223	25	Requested	Advanced	7	\N	Seeded request	2025-11-08 13:46:27.264874
176	17	Requested	Advanced	4	Rarely	Seeded assignment	\N
681	3	Requested	Expert	8	Rarely	Seeded request	\N
454	7	Requested	Beginner	5	\N	Seeded assignment	\N
957	16	Approved	\N	\N	\N	Seeded assignment	\N
530	12	Requested	Advanced	3	Daily	Seeded request	\N
502	8	Approved	Beginner	\N	\N	Seeded assignment	2025-11-05 03:45:27.264874
444	19	Approved	\N	\N	\N	Seeded assignment	\N
975	21	Requested	Advanced	2	\N	Seeded request	2025-11-08 06:36:27.264874
165	5	Approved	Beginner	\N	\N	Seeded request	\N
653	12	Requested	\N	\N	Monthly	Seeded assignment	\N
289	20	Requested	Beginner	2	\N	Seeded request	\N
568	24	Approved	\N	\N	Monthly	Seeded assignment	\N
981	21	Approved	Beginner	1	Monthly	Seeded request	2025-11-11 01:55:27.264874
117	23	Approved	\N	3	Weekly	Seeded assignment	\N
650	24	Approved	\N	2	Daily	Seeded request	2025-11-20 22:44:27.264874
577	3	Approved	Advanced	\N	\N	Seeded request	\N
941	20	Requested	\N	\N	Rarely	Seeded assignment	2025-11-26 11:07:27.264874
938	19	Approved	Expert	\N	Rarely	Seeded assignment	2025-11-17 11:58:27.264874
701	20	Approved	\N	3	Monthly	Seeded request	2025-11-10 02:30:27.264874
101	9	Requested	\N	1	\N	Seeded request	2025-11-28 12:12:27.264874
584	10	Requested	Expert	1	\N	Seeded assignment	\N
550	3	Approved	\N	\N	\N	Seeded request	\N
379	16	Approved	\N	6	\N	Seeded assignment	2025-11-11 14:26:27.264874
220	17	Approved	\N	10	\N	Seeded request	\N
643	12	Requested	Beginner	\N	Daily	Seeded assignment	\N
976	13	Approved	Expert	\N	Rarely	Seeded assignment	2025-11-16 17:04:27.264874
826	6	Approved	Beginner	0	Monthly	Seeded assignment	2025-11-23 01:10:27.264874
897	13	Approved	Expert	2	\N	Seeded assignment	\N
745	4	Approved	Beginner	5	Weekly	Seeded request	\N
346	19	Approved	\N	\N	Weekly	Seeded assignment	\N
48	7	Approved	Beginner	\N	Rarely	Seeded assignment	\N
910	16	Approved	Beginner	2	Daily	Seeded assignment	2025-11-09 06:23:27.264874
7	25	Requested	Beginner	\N	Monthly	Seeded request	2025-11-28 00:12:27.264874
16	24	Approved	Intermediate	4	\N	Seeded request	\N
197	23	Requested	Expert	\N	\N	Seeded request	\N
515	5	Approved	Expert	9	Weekly	Seeded assignment	\N
916	17	Approved	\N	7	\N	Seeded assignment	\N
982	10	Approved	\N	\N	Daily	Seeded assignment	\N
369	6	Approved	\N	\N	Rarely	Seeded request	\N
622	7	Requested	\N	5	Rarely	Seeded assignment	\N
984	19	Approved	\N	\N	Weekly	Seeded request	\N
384	3	Approved	Expert	2	\N	Seeded request	2025-11-23 18:39:27.264874
600	11	Approved	Advanced	7	Rarely	Seeded assignment	2025-11-18 22:22:27.264874
879	5	Requested	\N	10	\N	Seeded assignment	\N
82	1	Approved	Beginner	\N	Rarely	Seeded assignment	\N
593	18	Approved	Intermediate	\N	\N	Seeded request	2025-11-09 07:59:27.264874
360	21	Requested	Expert	\N	Daily	Seeded assignment	\N
702	23	Approved	\N	\N	Rarely	Seeded request	2025-11-16 15:14:27.264874
26	22	Approved	\N	8	Rarely	Seeded assignment	\N
202	20	Approved	Advanced	7	\N	Seeded assignment	2025-11-09 11:57:27.264874
394	8	Requested	\N	9	\N	Seeded assignment	2025-11-08 02:11:27.264874
771	10	Requested	Expert	\N	\N	Seeded request	\N
111	21	Approved	Advanced	0	Weekly	Seeded assignment	2025-11-28 02:06:27.264874
562	21	Approved	Intermediate	\N	\N	Seeded assignment	\N
887	9	Requested	\N	1	Monthly	Seeded assignment	\N
922	6	Approved	\N	\N	\N	Seeded assignment	2025-12-03 01:21:27.264874
767	23	Requested	Expert	\N	Rarely	Seeded request	2025-11-11 16:31:27.264874
359	22	Approved	Intermediate	\N	Weekly	Seeded assignment	2025-11-14 17:40:27.264874
213	1	Approved	Advanced	9	\N	Seeded assignment	\N
571	7	Approved	\N	6	Monthly	Seeded request	\N
952	5	Requested	Advanced	0	Rarely	Seeded assignment	\N
928	20	Approved	Advanced	\N	Daily	Seeded assignment	\N
598	17	Approved	\N	\N	Weekly	Seeded assignment	\N
890	21	Approved	\N	\N	Daily	Seeded request	\N
91	13	Requested	Intermediate	4	Daily	Seeded assignment	2025-11-27 18:56:27.264874
13	13	Requested	\N	\N	\N	Seeded request	\N
625	18	Approved	\N	3	Rarely	Seeded assignment	2025-11-06 19:11:27.264874
801	9	Requested	\N	9	\N	Seeded request	2025-11-14 17:47:27.264874
409	23	Approved	\N	\N	\N	Seeded assignment	\N
148	24	Approved	\N	10	\N	Seeded assignment	2025-11-09 07:54:27.264874
236	24	Requested	Advanced	\N	Weekly	Seeded assignment	\N
330	3	Approved	\N	5	\N	Seeded assignment	\N
472	17	Approved	Intermediate	1	Weekly	Seeded assignment	\N
620	3	Approved	Intermediate	0	\N	Seeded request	\N
209	9	Requested	Expert	0	\N	Seeded request	2025-11-22 10:27:27.264874
544	21	Approved	\N	0	\N	Seeded request	2025-11-05 12:35:27.264874
218	1	Approved	\N	10	\N	Seeded assignment	2025-11-26 08:04:27.264874
440	11	Approved	\N	\N	Monthly	Seeded assignment	2025-11-07 10:36:27.264874
854	24	Approved	Expert	\N	\N	Seeded request	\N
286	23	Approved	\N	1	Monthly	Seeded request	2025-11-15 16:18:27.264874
63	25	Approved	Intermediate	4	Daily	Seeded assignment	\N
851	19	Approved	Advanced	\N	\N	Seeded request	\N
233	13	Approved	Intermediate	3	Monthly	Seeded request	\N
52	11	Requested	\N	\N	\N	Seeded assignment	2025-12-01 20:51:27.264874
694	12	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-25 13:59:27.264874
129	7	Approved	\N	\N	Rarely	Seeded request	\N
195	7	Approved	\N	10	Weekly	Seeded request	\N
907	3	Approved	\N	5	Rarely	Seeded request	2025-11-06 02:42:27.264874
337	8	Approved	\N	7	Daily	Seeded assignment	\N
746	4	Approved	\N	1	Rarely	Seeded request	2025-12-01 10:15:27.264874
405	17	Requested	\N	4	\N	Seeded assignment	2025-11-13 21:55:27.264874
491	3	Approved	Intermediate	5	\N	Seeded request	\N
705	8	Approved	\N	\N	Rarely	Seeded assignment	\N
811	18	Requested	\N	1	\N	Seeded assignment	2025-11-14 01:37:27.264874
202	7	Approved	Beginner	0	Rarely	Seeded request	\N
807	25	Approved	\N	9	Monthly	Seeded request	\N
886	8	Approved	Expert	\N	\N	Seeded request	2025-11-13 20:12:27.264874
306	3	Approved	Advanced	\N	\N	Seeded assignment	2025-11-26 05:57:27.264874
292	17	Requested	\N	4	\N	Seeded assignment	2025-11-22 07:34:27.264874
632	12	Requested	\N	7	\N	Seeded assignment	\N
417	18	Requested	Expert	1	\N	Seeded request	\N
409	12	Approved	Advanced	3	Rarely	Seeded assignment	2025-11-18 07:40:27.264874
605	18	Approved	Advanced	\N	Monthly	Seeded assignment	\N
785	10	Approved	Advanced	\N	\N	Seeded assignment	\N
963	3	Approved	Intermediate	3	Rarely	Seeded request	2025-11-07 20:48:27.264874
659	1	Requested	\N	\N	Weekly	Seeded assignment	\N
57	21	Requested	\N	0	\N	Seeded request	2025-11-07 01:45:27.264874
399	25	Approved	\N	2	Weekly	Seeded request	\N
852	25	Approved	Beginner	\N	Rarely	Seeded assignment	2025-11-04 17:16:27.264874
691	12	Approved	Beginner	8	Monthly	Seeded assignment	2025-11-22 07:27:27.264874
896	23	Approved	Advanced	\N	Monthly	Seeded request	\N
955	5	Requested	Intermediate	7	\N	Seeded request	\N
645	16	Requested	\N	\N	\N	Seeded assignment	\N
134	19	Requested	Beginner	8	\N	Seeded assignment	2025-11-26 17:39:27.264874
479	21	Approved	\N	\N	Daily	Seeded assignment	2025-11-13 17:33:27.264874
930	20	Approved	\N	\N	Daily	Seeded assignment	\N
903	20	Approved	Beginner	9	Rarely	Seeded request	2025-11-25 19:48:27.264874
400	8	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
715	19	Requested	\N	\N	Rarely	Seeded assignment	\N
406	13	Approved	\N	\N	Monthly	Seeded assignment	\N
822	23	Requested	\N	\N	Rarely	Seeded assignment	2025-11-08 12:56:27.264874
819	8	Approved	Expert	\N	Monthly	Seeded assignment	\N
767	12	Requested	\N	4	Monthly	Seeded assignment	2025-11-24 03:37:27.264874
183	3	Approved	Expert	8	Weekly	Seeded request	\N
971	20	Approved	\N	5	Monthly	Seeded assignment	\N
300	7	Approved	Advanced	2	Daily	Seeded request	\N
186	24	Approved	\N	\N	Daily	Seeded assignment	2025-11-07 05:16:27.264874
731	16	Requested	Expert	\N	Weekly	Seeded request	2025-11-25 19:41:27.264874
87	16	Approved	\N	4	Rarely	Seeded request	2025-11-29 15:21:27.264874
535	7	Approved	Expert	\N	\N	Seeded request	2025-11-24 20:19:27.264874
795	11	Approved	\N	7	Weekly	Seeded assignment	\N
395	5	Approved	\N	0	\N	Seeded assignment	\N
349	11	Approved	Expert	4	Rarely	Seeded assignment	\N
187	18	Requested	Beginner	2	\N	Seeded assignment	\N
707	20	Requested	Advanced	2	Monthly	Seeded assignment	2025-11-15 08:39:27.264874
471	21	Approved	\N	2	Weekly	Seeded assignment	\N
612	9	Approved	\N	3	Monthly	Seeded request	\N
745	17	Approved	\N	\N	Monthly	Seeded assignment	2025-11-06 21:04:27.264874
521	19	Requested	Beginner	0	\N	Seeded request	\N
67	5	Approved	Expert	\N	Daily	Seeded request	2025-11-13 17:24:27.264874
457	5	Requested	Advanced	0	Weekly	Seeded assignment	\N
226	6	Approved	Advanced	4	Rarely	Seeded request	\N
752	24	Approved	\N	5	Rarely	Seeded assignment	\N
747	1	Approved	Intermediate	8	\N	Seeded assignment	\N
500	6	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
130	3	Approved	Beginner	5	Daily	Seeded assignment	2025-11-04 20:05:27.264874
120	25	Approved	\N	\N	\N	Seeded request	\N
516	19	Approved	Intermediate	\N	\N	Seeded request	\N
776	16	Requested	Advanced	\N	Rarely	Seeded request	2025-11-29 16:50:27.264874
573	22	Requested	\N	0	Rarely	Seeded request	2025-11-27 12:15:27.264874
548	3	Requested	Beginner	\N	Daily	Seeded assignment	\N
824	16	Requested	Beginner	8	Weekly	Seeded request	2025-12-01 18:17:27.264874
911	4	Approved	Intermediate	4	Monthly	Seeded request	\N
161	4	Approved	Advanced	8	Daily	Seeded request	\N
771	1	Requested	\N	1	Daily	Seeded assignment	\N
840	19	Approved	\N	6	Rarely	Seeded assignment	2025-11-11 23:03:27.264874
716	4	Requested	\N	\N	Weekly	Seeded assignment	\N
692	7	Approved	\N	10	Rarely	Seeded request	\N
916	4	Requested	Advanced	\N	\N	Seeded assignment	\N
108	23	Approved	Expert	\N	Daily	Seeded assignment	2025-11-24 12:23:27.264874
657	4	Approved	Advanced	1	\N	Seeded assignment	\N
950	11	Approved	Intermediate	5	\N	Seeded assignment	2025-11-19 06:35:27.264874
6	19	Approved	Beginner	5	Weekly	Seeded request	\N
509	19	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-28 14:06:27.264874
520	5	Requested	\N	\N	Weekly	Seeded request	2025-11-27 05:09:27.264874
717	11	Requested	\N	6	Monthly	Seeded assignment	2025-11-19 11:18:27.264874
838	17	Requested	\N	\N	Rarely	Seeded assignment	2025-11-25 00:29:27.264874
749	3	Approved	Expert	6	\N	Seeded assignment	\N
835	5	Requested	\N	\N	\N	Seeded request	2025-11-06 01:40:27.264874
649	16	Approved	\N	10	Weekly	Seeded assignment	\N
173	9	Approved	Intermediate	9	Weekly	Seeded assignment	\N
488	19	Approved	Beginner	\N	Daily	Seeded request	2025-11-28 20:04:27.264874
117	12	Requested	Beginner	0	Weekly	Seeded assignment	2025-11-11 13:44:27.264874
522	1	Requested	Beginner	\N	\N	Seeded assignment	\N
590	8	Approved	Intermediate	\N	\N	Seeded request	\N
940	18	Requested	\N	\N	\N	Seeded request	2025-11-24 23:30:27.264874
672	24	Approved	Intermediate	2	Monthly	Seeded assignment	\N
295	21	Requested	Intermediate	9	\N	Seeded request	\N
797	22	Approved	\N	\N	\N	Seeded request	\N
3	1	Requested	\N	\N	\N	Seeded assignment	\N
269	5	Approved	Expert	\N	Daily	Seeded request	\N
221	23	Requested	\N	2	\N	Seeded assignment	\N
944	16	Requested	Beginner	2	\N	Seeded assignment	\N
212	3	Approved	Beginner	\N	\N	Seeded request	2025-11-21 07:41:27.264874
942	17	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-30 06:17:27.264874
358	7	Approved	Beginner	10	Weekly	Seeded assignment	\N
201	1	Approved	\N	\N	Rarely	Seeded assignment	\N
423	22	Approved	\N	1	Monthly	Seeded assignment	2025-11-10 22:31:27.264874
943	9	Requested	\N	5	\N	Seeded request	2025-11-13 04:20:27.264874
922	13	Requested	Beginner	4	Daily	Seeded request	\N
193	24	Approved	Advanced	\N	Rarely	Seeded request	\N
373	10	Approved	Expert	\N	Rarely	Seeded assignment	2025-11-25 02:30:27.264874
484	6	Requested	\N	\N	Rarely	Seeded assignment	\N
553	18	Requested	\N	2	Weekly	Seeded assignment	2025-11-08 01:26:27.264874
558	5	Requested	Beginner	\N	\N	Seeded request	2025-11-21 16:12:27.264874
94	18	Approved	Advanced	10	\N	Seeded assignment	2025-11-23 11:48:27.264874
699	18	Approved	\N	7	Daily	Seeded assignment	2025-11-25 09:48:27.264874
504	24	Requested	\N	1	\N	Seeded assignment	2025-11-23 21:44:27.264874
362	18	Approved	\N	\N	Daily	Seeded request	\N
843	21	Requested	\N	\N	Weekly	Seeded request	\N
868	6	Approved	Advanced	\N	Monthly	Seeded request	\N
332	6	Requested	Expert	\N	\N	Seeded assignment	2025-11-29 13:17:27.264874
739	23	Approved	Beginner	8	\N	Seeded request	\N
803	23	Approved	Beginner	\N	Daily	Seeded request	2025-11-14 02:49:27.264874
551	11	Approved	Beginner	0	\N	Seeded assignment	\N
267	5	Requested	Expert	\N	\N	Seeded request	\N
643	7	Requested	Expert	3	Weekly	Seeded request	\N
387	13	Requested	\N	\N	\N	Seeded request	\N
711	4	Approved	\N	2	\N	Seeded request	2025-11-17 23:58:27.264874
804	23	Requested	Expert	0	\N	Seeded assignment	\N
915	8	Approved	Beginner	9	Weekly	Seeded assignment	2025-11-15 14:49:27.264874
179	11	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
277	6	Requested	Beginner	\N	Monthly	Seeded request	\N
270	10	Requested	Expert	2	\N	Seeded assignment	\N
378	19	Approved	Intermediate	\N	\N	Seeded request	\N
812	24	Requested	\N	5	Weekly	Seeded assignment	\N
95	12	Requested	Intermediate	0	Daily	Seeded request	\N
261	6	Approved	Advanced	2	\N	Seeded assignment	2025-11-23 19:46:27.264874
246	5	Requested	Expert	10	Monthly	Seeded assignment	2025-11-16 22:17:27.264874
289	23	Requested	\N	2	Rarely	Seeded request	\N
285	17	Requested	Advanced	\N	\N	Seeded assignment	2025-11-19 15:47:27.264874
653	7	Approved	Advanced	10	Rarely	Seeded assignment	\N
709	20	Approved	\N	10	Rarely	Seeded request	2025-11-27 12:53:27.264874
454	12	Requested	Advanced	10	Weekly	Seeded assignment	2025-11-27 12:19:27.264874
556	8	Approved	\N	2	Rarely	Seeded assignment	2025-12-02 23:45:27.264874
616	22	Requested	\N	5	Monthly	Seeded assignment	\N
877	11	Requested	Advanced	2	Daily	Seeded request	\N
601	17	Approved	\N	\N	\N	Seeded request	2025-11-11 07:00:27.264874
73	6	Approved	Advanced	7	Weekly	Seeded request	2025-11-06 09:43:27.264874
866	17	Approved	Expert	5	\N	Seeded request	2025-11-09 03:47:27.264874
862	5	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-24 08:42:27.264874
501	5	Requested	\N	\N	\N	Seeded request	\N
566	8	Approved	Intermediate	5	Monthly	Seeded request	\N
900	24	Approved	Expert	3	\N	Seeded request	\N
452	17	Requested	Expert	0	\N	Seeded request	\N
878	1	Approved	\N	\N	Weekly	Seeded request	\N
967	11	Requested	\N	6	\N	Seeded assignment	\N
266	23	Approved	Expert	\N	\N	Seeded assignment	\N
114	20	Approved	Expert	\N	Weekly	Seeded request	\N
695	8	Approved	\N	4	\N	Seeded request	2025-11-22 07:37:27.264874
750	20	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-11 22:54:27.264874
450	13	Approved	Intermediate	6	Daily	Seeded request	\N
784	1	Requested	Expert	\N	Daily	Seeded request	\N
212	4	Approved	\N	\N	Daily	Seeded request	2025-11-17 15:19:27.264874
598	3	Approved	\N	\N	\N	Seeded request	2025-11-04 19:31:27.264874
79	13	Approved	Expert	10	Daily	Seeded assignment	2025-11-16 12:41:27.264874
973	19	Approved	\N	\N	Weekly	Seeded request	2025-11-10 03:33:27.264874
312	18	Approved	Expert	2	Daily	Seeded assignment	\N
683	18	Requested	\N	\N	Weekly	Seeded assignment	\N
330	17	Requested	\N	6	Rarely	Seeded assignment	\N
903	12	Requested	Beginner	0	Rarely	Seeded request	\N
962	4	Approved	Expert	3	Rarely	Seeded request	\N
930	12	Requested	Expert	6	Rarely	Seeded assignment	\N
265	25	Approved	Beginner	4	\N	Seeded assignment	2025-11-29 00:05:27.264874
272	16	Approved	\N	4	\N	Seeded request	\N
477	19	Requested	\N	\N	\N	Seeded request	\N
178	24	Requested	\N	5	Rarely	Seeded assignment	\N
928	23	Approved	\N	1	Rarely	Seeded request	\N
287	8	Approved	\N	\N	Rarely	Seeded request	\N
180	11	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-10 05:42:27.264874
896	7	Approved	Beginner	5	\N	Seeded assignment	2025-11-17 19:20:27.264874
328	16	Requested	Intermediate	\N	\N	Seeded request	2025-11-27 04:37:27.264874
926	1	Requested	Intermediate	3	Rarely	Seeded request	\N
409	20	Requested	\N	5	Weekly	Seeded assignment	\N
300	23	Requested	\N	9	\N	Seeded assignment	\N
657	3	Approved	\N	1	Monthly	Seeded request	\N
986	20	Approved	\N	\N	Daily	Seeded assignment	\N
470	18	Approved	Intermediate	\N	Weekly	Seeded request	\N
168	25	Requested	\N	\N	\N	Seeded assignment	2025-12-03 01:03:27.264874
627	6	Approved	Beginner	\N	\N	Seeded request	2025-11-09 12:45:27.264874
559	24	Requested	\N	\N	\N	Seeded assignment	\N
632	20	Approved	Beginner	9	\N	Seeded assignment	2025-11-16 05:47:27.264874
606	10	Approved	Expert	\N	Monthly	Seeded assignment	\N
384	17	Approved	\N	7	Daily	Seeded request	\N
522	9	Approved	\N	\N	Monthly	Seeded assignment	\N
622	12	Approved	\N	\N	Weekly	Seeded request	2025-11-06 20:24:27.264874
557	5	Requested	Advanced	\N	Daily	Seeded request	2025-11-27 06:30:27.264874
700	17	Requested	\N	\N	Daily	Seeded assignment	2025-11-03 17:26:27.264874
255	25	Approved	Expert	\N	\N	Seeded request	2025-12-02 20:36:27.264874
84	18	Approved	\N	5	\N	Seeded assignment	2025-11-16 14:46:27.264874
397	21	Approved	\N	10	\N	Seeded assignment	\N
663	4	Requested	Intermediate	7	Monthly	Seeded assignment	2025-11-07 12:09:27.264874
281	7	Approved	\N	5	\N	Seeded assignment	2025-11-30 01:47:27.264874
611	9	Requested	\N	\N	\N	Seeded request	2025-11-18 14:59:27.264874
171	16	Approved	\N	10	\N	Seeded assignment	2025-11-20 15:29:27.264874
407	22	Requested	Beginner	\N	Monthly	Seeded assignment	\N
501	12	Approved	Expert	10	\N	Seeded request	\N
680	4	Approved	Expert	5	\N	Seeded assignment	\N
408	17	Approved	\N	\N	Monthly	Seeded request	2025-11-07 16:09:27.264874
904	16	Approved	\N	\N	Daily	Seeded assignment	2025-11-16 03:19:27.264874
4	1	Requested	Advanced	6	Weekly	Seeded request	\N
21	7	Requested	Advanced	\N	\N	Seeded request	\N
595	23	Requested	Advanced	8	\N	Seeded request	2025-11-05 02:50:27.264874
751	5	Approved	Beginner	8	Daily	Seeded assignment	\N
47	23	Approved	Beginner	8	Monthly	Seeded assignment	2025-11-21 01:49:27.264874
828	5	Approved	Expert	9	Weekly	Seeded assignment	2025-11-28 16:45:27.264874
814	3	Requested	Advanced	5	\N	Seeded assignment	2025-11-13 12:40:27.264874
225	9	Approved	Advanced	\N	Weekly	Seeded assignment	\N
748	7	Approved	\N	2	\N	Seeded request	2025-11-04 23:44:27.264874
104	10	Approved	Expert	\N	Monthly	Seeded assignment	\N
214	21	Requested	\N	1	Monthly	Seeded assignment	\N
623	5	Requested	Intermediate	8	Weekly	Seeded request	\N
165	7	Approved	Advanced	\N	\N	Seeded assignment	2025-11-13 13:32:27.264874
356	5	Requested	Beginner	3	Weekly	Seeded assignment	\N
371	22	Approved	\N	4	\N	Seeded assignment	\N
159	12	Approved	\N	0	\N	Seeded assignment	\N
112	8	Approved	\N	\N	\N	Seeded assignment	2025-11-11 13:32:27.264874
267	12	Approved	\N	6	\N	Seeded assignment	\N
613	1	Approved	\N	7	Monthly	Seeded assignment	2025-11-11 13:14:27.264874
779	25	Approved	\N	\N	Monthly	Seeded assignment	2025-11-30 09:47:27.264874
700	21	Approved	Intermediate	9	\N	Seeded assignment	\N
204	5	Approved	Expert	6	Monthly	Seeded request	\N
206	3	Requested	Beginner	\N	\N	Seeded request	\N
288	25	Requested	Expert	0	Monthly	Seeded assignment	2025-11-25 02:58:27.264874
840	18	Approved	Intermediate	3	\N	Seeded request	\N
810	16	Requested	Advanced	1	\N	Seeded assignment	\N
275	22	Approved	\N	\N	Daily	Seeded assignment	2025-11-04 07:18:27.264874
531	13	Approved	Beginner	6	\N	Seeded assignment	2025-11-06 07:49:27.264874
738	25	Approved	Expert	\N	\N	Seeded request	2025-11-27 21:53:27.264874
558	20	Approved	\N	10	Weekly	Seeded assignment	\N
568	1	Approved	Advanced	0	\N	Seeded assignment	\N
713	18	Approved	\N	\N	Monthly	Seeded assignment	\N
41	18	Approved	\N	\N	\N	Seeded request	\N
237	3	Requested	\N	8	\N	Seeded assignment	2025-11-23 01:49:27.264874
766	4	Requested	Intermediate	\N	\N	Seeded assignment	\N
817	25	Approved	\N	\N	Monthly	Seeded assignment	\N
895	9	Approved	\N	8	Weekly	Seeded assignment	\N
981	3	Requested	\N	5	\N	Seeded request	\N
521	18	Requested	Expert	10	\N	Seeded assignment	\N
248	11	Requested	\N	4	Rarely	Seeded assignment	2025-11-18 19:40:27.264874
222	4	Requested	Beginner	\N	Rarely	Seeded request	\N
954	8	Requested	\N	9	\N	Seeded assignment	2025-11-17 12:09:27.264874
92	4	Approved	Advanced	\N	Rarely	Seeded assignment	2025-11-22 01:17:27.264874
945	3	Approved	Intermediate	2	Rarely	Seeded request	2025-11-21 01:55:27.264874
158	6	Requested	Beginner	\N	\N	Seeded assignment	\N
723	7	Requested	Advanced	\N	Weekly	Seeded request	\N
187	19	Requested	Beginner	6	\N	Seeded request	2025-11-28 12:03:27.264874
191	25	Approved	Intermediate	4	Daily	Seeded request	\N
778	12	Approved	Advanced	4	Weekly	Seeded request	\N
138	22	Requested	Advanced	0	Monthly	Seeded assignment	\N
729	23	Approved	\N	1	Weekly	Seeded request	\N
780	3	Approved	Advanced	\N	\N	Seeded request	\N
483	13	Approved	Advanced	3	\N	Seeded assignment	2025-11-25 20:15:27.264874
715	18	Approved	Beginner	\N	\N	Seeded assignment	2025-11-05 23:27:27.264874
16	1	Requested	\N	4	Rarely	Seeded assignment	2025-11-25 19:50:27.264874
228	25	Approved	Intermediate	9	Rarely	Seeded request	\N
82	24	Requested	\N	5	Daily	Seeded assignment	2025-11-28 06:12:27.264874
39	25	Approved	Advanced	3	\N	Seeded assignment	2025-11-09 07:39:27.264874
638	6	Approved	\N	\N	Rarely	Seeded request	\N
124	3	Requested	Beginner	\N	\N	Seeded assignment	2025-11-09 00:09:27.264874
342	1	Approved	\N	7	\N	Seeded assignment	\N
658	20	Requested	\N	10	Weekly	Seeded assignment	\N
323	22	Approved	\N	0	Monthly	Seeded assignment	2025-11-08 18:12:27.264874
497	21	Requested	\N	6	Weekly	Seeded assignment	2025-11-27 22:34:27.264874
572	9	Approved	Advanced	8	\N	Seeded assignment	\N
647	21	Approved	Expert	0	Weekly	Seeded request	\N
955	20	Requested	\N	\N	Monthly	Seeded request	\N
452	21	Approved	Advanced	\N	\N	Seeded assignment	\N
712	7	Approved	\N	\N	\N	Seeded assignment	\N
567	20	Requested	\N	9	Monthly	Seeded assignment	2025-12-03 03:51:27.264874
53	16	Approved	Expert	9	\N	Seeded request	2025-11-27 21:24:27.264874
52	8	Approved	Intermediate	9	\N	Seeded assignment	\N
888	1	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
681	21	Approved	\N	1	Daily	Seeded assignment	2025-11-21 04:47:27.264874
794	18	Requested	\N	2	Rarely	Seeded request	2025-11-18 14:42:27.264874
761	20	Approved	Beginner	\N	\N	Seeded assignment	\N
975	3	Requested	\N	4	\N	Seeded assignment	2025-11-11 07:15:27.264874
811	19	Requested	Intermediate	\N	\N	Seeded request	\N
601	21	Requested	Intermediate	9	Rarely	Seeded request	\N
211	23	Approved	\N	0	Rarely	Seeded request	\N
468	7	Approved	\N	\N	\N	Seeded assignment	\N
672	10	Requested	\N	\N	Rarely	Seeded request	\N
866	21	Requested	\N	\N	Daily	Seeded assignment	\N
440	8	Requested	\N	8	\N	Seeded assignment	\N
766	3	Approved	\N	5	Daily	Seeded request	\N
882	17	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
32	8	Approved	Expert	8	Weekly	Seeded request	2025-12-01 03:40:27.264874
116	20	Approved	Intermediate	2	\N	Seeded request	\N
891	7	Approved	\N	7	Daily	Seeded request	\N
515	23	Approved	Expert	5	Rarely	Seeded assignment	2025-11-09 15:30:27.264874
929	16	Approved	\N	7	Weekly	Seeded request	\N
849	18	Approved	\N	3	Daily	Seeded assignment	\N
155	13	Requested	Expert	\N	Rarely	Seeded request	\N
562	4	Approved	Intermediate	\N	Weekly	Seeded request	\N
546	8	Requested	\N	7	Daily	Seeded request	2025-11-10 15:33:27.264874
470	19	Approved	Expert	1	\N	Seeded assignment	\N
767	5	Approved	Expert	0	Monthly	Seeded request	2025-11-25 15:24:27.264874
793	16	Requested	Advanced	10	Rarely	Seeded assignment	2025-11-12 02:08:27.264874
258	6	Approved	\N	\N	\N	Seeded assignment	2025-11-11 23:42:27.264874
734	20	Approved	Advanced	\N	\N	Seeded request	\N
980	10	Requested	Intermediate	1	Daily	Seeded request	2025-11-30 21:52:27.264874
389	5	Approved	Advanced	6	\N	Seeded request	\N
33	10	Requested	\N	2	\N	Seeded assignment	2025-12-02 05:52:27.264874
311	3	Approved	\N	\N	Weekly	Seeded assignment	\N
294	9	Requested	\N	\N	\N	Seeded assignment	2025-11-26 03:00:27.264874
278	8	Approved	Beginner	\N	\N	Seeded assignment	2025-11-29 21:59:27.264874
382	21	Approved	\N	0	\N	Seeded request	2025-11-08 11:54:27.264874
923	23	Approved	\N	1	\N	Seeded assignment	\N
19	6	Approved	Intermediate	1	Rarely	Seeded request	\N
247	3	Approved	Advanced	7	Monthly	Seeded assignment	\N
934	11	Approved	\N	7	\N	Seeded assignment	\N
56	7	Requested	Advanced	1	Weekly	Seeded assignment	\N
305	19	Requested	\N	\N	\N	Seeded request	2025-11-13 12:27:27.264874
583	9	Requested	Expert	\N	Monthly	Seeded assignment	\N
676	5	Requested	Expert	1	\N	Seeded assignment	\N
101	24	Approved	\N	0	Daily	Seeded request	\N
416	8	Approved	Beginner	\N	Weekly	Seeded assignment	\N
909	1	Requested	\N	3	\N	Seeded request	\N
409	5	Requested	Beginner	\N	Weekly	Seeded assignment	2025-11-08 09:06:27.264874
77	7	Approved	\N	\N	\N	Seeded request	\N
318	19	Approved	\N	9	\N	Seeded assignment	\N
576	6	Requested	Beginner	\N	Weekly	Seeded assignment	2025-11-12 11:39:27.264874
125	7	Approved	\N	8	\N	Seeded assignment	\N
815	17	Approved	Advanced	2	\N	Seeded request	\N
286	5	Requested	Beginner	10	Monthly	Seeded assignment	2025-11-17 04:22:27.264874
778	20	Requested	\N	9	Monthly	Seeded assignment	\N
295	17	Approved	Beginner	9	Rarely	Seeded assignment	2025-11-29 14:59:27.264874
11	17	Approved	\N	\N	\N	Seeded request	\N
427	8	Approved	Advanced	6	\N	Seeded request	2025-11-09 11:30:27.264874
327	22	Requested	\N	10	\N	Seeded request	\N
820	6	Requested	Advanced	\N	Weekly	Seeded request	2025-11-27 00:45:27.264874
961	13	Approved	\N	\N	Rarely	Seeded request	\N
510	1	Approved	\N	3	\N	Seeded request	\N
575	23	Requested	Expert	2	\N	Seeded assignment	2025-12-02 19:43:27.264874
81	20	Requested	Expert	0	\N	Seeded assignment	\N
890	4	Requested	Expert	\N	Daily	Seeded assignment	2025-11-18 14:58:27.264874
321	25	Requested	\N	8	Weekly	Seeded request	2025-11-21 04:26:27.264874
401	23	Approved	Expert	\N	Rarely	Seeded request	\N
570	23	Approved	Intermediate	0	Monthly	Seeded assignment	\N
47	7	Requested	Expert	10	\N	Seeded request	2025-11-24 11:13:27.264874
511	18	Requested	\N	\N	Monthly	Seeded assignment	2025-12-02 12:29:27.264874
887	24	Approved	Expert	8	Weekly	Seeded request	\N
267	20	Requested	Intermediate	\N	\N	Seeded assignment	\N
415	4	Requested	\N	6	Daily	Seeded request	\N
58	22	Approved	\N	\N	Rarely	Seeded assignment	\N
31	17	Approved	Beginner	\N	Daily	Seeded request	\N
728	8	Requested	\N	\N	Weekly	Seeded assignment	\N
714	10	Requested	Expert	0	Rarely	Seeded assignment	\N
673	6	Approved	\N	\N	\N	Seeded assignment	\N
75	4	Approved	Advanced	3	Daily	Seeded assignment	2025-11-19 18:43:27.264874
174	3	Approved	Beginner	7	Weekly	Seeded assignment	\N
143	25	Approved	Intermediate	\N	Rarely	Seeded request	\N
539	9	Requested	\N	5	Daily	Seeded request	\N
660	11	Requested	Intermediate	5	\N	Seeded request	\N
748	23	Approved	Advanced	\N	Weekly	Seeded request	\N
848	25	Requested	\N	7	\N	Seeded assignment	\N
856	24	Approved	\N	7	Monthly	Seeded assignment	\N
912	22	Approved	Beginner	1	Monthly	Seeded assignment	\N
314	7	Requested	Intermediate	3	\N	Seeded assignment	2025-11-07 18:16:27.264874
465	17	Approved	Advanced	\N	Rarely	Seeded assignment	2025-11-16 18:47:27.264874
419	7	Approved	\N	1	Weekly	Seeded request	2025-11-20 08:25:27.264874
392	6	Approved	Expert	6	\N	Seeded request	2025-11-12 20:37:27.264874
528	3	Requested	Advanced	8	Rarely	Seeded request	\N
381	25	Approved	\N	4	\N	Seeded assignment	\N
513	11	Requested	\N	\N	\N	Seeded assignment	\N
745	21	Approved	Intermediate	\N	Daily	Seeded assignment	2025-11-29 16:13:27.264874
606	24	Approved	Intermediate	0	Weekly	Seeded assignment	\N
780	4	Requested	\N	\N	\N	Seeded assignment	2025-11-24 21:50:27.264874
526	10	Approved	\N	1	\N	Seeded assignment	\N
675	5	Approved	Expert	4	Rarely	Seeded request	2025-11-10 07:13:27.264874
563	17	Approved	Intermediate	1	Rarely	Seeded request	\N
529	11	Approved	Expert	0	Weekly	Seeded assignment	2025-11-25 12:29:27.264874
862	20	Requested	Expert	3	Weekly	Seeded assignment	\N
457	12	Approved	Intermediate	0	Rarely	Seeded assignment	\N
742	18	Requested	Expert	7	\N	Seeded request	\N
342	9	Requested	Expert	2	Rarely	Seeded assignment	2025-11-11 11:27:27.264874
545	13	Approved	\N	\N	\N	Seeded request	2025-11-14 21:23:27.264874
981	4	Requested	\N	\N	\N	Seeded request	\N
69	11	Requested	Beginner	5	Rarely	Seeded request	\N
222	3	Requested	Intermediate	\N	Weekly	Seeded request	\N
860	1	Requested	\N	0	\N	Seeded assignment	\N
503	5	Approved	\N	3	\N	Seeded request	\N
635	21	Approved	Intermediate	\N	Daily	Seeded assignment	2025-11-16 11:42:27.264874
955	22	Requested	\N	\N	Monthly	Seeded assignment	\N
825	6	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-10 03:12:27.264874
974	23	Requested	Intermediate	0	Weekly	Seeded request	\N
481	3	Requested	\N	\N	Daily	Seeded request	2025-11-18 07:23:27.264874
906	18	Approved	Expert	3	Monthly	Seeded request	2025-11-06 06:28:27.264874
658	22	Approved	Beginner	\N	Rarely	Seeded assignment	\N
121	13	Approved	Advanced	2	Daily	Seeded assignment	2025-11-18 11:05:27.264874
626	7	Approved	\N	\N	Weekly	Seeded assignment	\N
703	1	Approved	Beginner	1	Monthly	Seeded request	2025-11-25 19:58:27.264874
351	16	Requested	Expert	\N	Monthly	Seeded assignment	2025-11-21 15:58:27.264874
361	25	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-11 20:12:27.264874
728	24	Approved	Expert	\N	\N	Seeded request	\N
780	18	Requested	\N	9	\N	Seeded request	\N
660	1	Approved	Expert	\N	Monthly	Seeded request	\N
489	23	Approved	\N	\N	Monthly	Seeded request	\N
735	1	Approved	\N	5	\N	Seeded request	2025-11-07 10:19:27.264874
394	9	Requested	\N	10	Weekly	Seeded request	\N
345	19	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
344	13	Approved	Advanced	8	Daily	Seeded request	2025-11-21 03:42:27.264874
302	16	Approved	Beginner	8	Rarely	Seeded assignment	2025-11-14 11:48:27.264874
386	16	Approved	Beginner	\N	\N	Seeded assignment	2025-11-30 08:46:27.264874
782	10	Approved	Beginner	4	Monthly	Seeded request	\N
824	13	Approved	Beginner	2	\N	Seeded assignment	2025-11-29 15:19:27.264874
73	25	Approved	Advanced	1	Rarely	Seeded request	\N
574	20	Approved	Beginner	8	Rarely	Seeded request	\N
788	4	Approved	Expert	9	\N	Seeded assignment	2025-12-02 07:55:27.264874
355	25	Approved	Advanced	\N	\N	Seeded assignment	2025-11-18 04:35:27.264874
608	11	Requested	\N	1	Weekly	Seeded request	\N
40	25	Approved	Advanced	5	\N	Seeded assignment	2025-11-05 21:17:27.264874
698	9	Requested	\N	\N	\N	Seeded assignment	\N
141	9	Approved	\N	7	Monthly	Seeded assignment	2025-11-28 11:58:27.264874
410	20	Approved	\N	3	Rarely	Seeded assignment	\N
922	16	Requested	\N	1	\N	Seeded request	2025-11-04 20:48:27.264874
975	18	Requested	\N	5	\N	Seeded request	2025-11-29 10:58:27.264874
506	16	Requested	Beginner	9	Rarely	Seeded assignment	\N
630	8	Approved	Advanced	0	Daily	Seeded assignment	\N
794	3	Approved	Beginner	10	Weekly	Seeded assignment	\N
380	20	Requested	Beginner	\N	Weekly	Seeded request	2025-11-28 19:44:27.264874
238	6	Requested	\N	8	Weekly	Seeded assignment	\N
126	4	Requested	\N	\N	\N	Seeded assignment	2025-11-27 11:53:27.264874
396	21	Approved	Intermediate	9	\N	Seeded assignment	\N
963	19	Approved	Beginner	2	Rarely	Seeded request	2025-11-13 00:09:27.264874
868	25	Requested	Beginner	4	Daily	Seeded assignment	\N
448	19	Approved	Beginner	8	Weekly	Seeded assignment	\N
463	9	Approved	Expert	9	Rarely	Seeded request	\N
596	17	Approved	Beginner	0	Monthly	Seeded assignment	2025-11-26 23:51:27.264874
124	18	Approved	\N	9	Weekly	Seeded request	2025-11-29 16:05:27.264874
592	19	Approved	Intermediate	1	\N	Seeded request	\N
935	21	Requested	\N	\N	\N	Seeded assignment	\N
740	19	Approved	Advanced	\N	\N	Seeded request	\N
677	12	Requested	Advanced	\N	Rarely	Seeded request	2025-11-26 01:29:27.264874
333	10	Approved	Expert	\N	Rarely	Seeded assignment	\N
534	22	Approved	\N	\N	Rarely	Seeded assignment	2025-11-20 21:07:27.264874
880	10	Requested	Expert	2	\N	Seeded request	\N
951	22	Requested	\N	\N	\N	Seeded request	2025-11-10 14:00:27.264874
74	3	Approved	Beginner	5	Weekly	Seeded assignment	\N
666	12	Approved	\N	6	\N	Seeded assignment	2025-11-03 11:46:27.264874
736	24	Approved	\N	5	\N	Seeded assignment	\N
743	11	Approved	Intermediate	\N	Weekly	Seeded request	\N
544	18	Approved	\N	6	\N	Seeded request	\N
475	17	Approved	Advanced	3	\N	Seeded assignment	\N
536	17	Approved	Intermediate	9	Monthly	Seeded assignment	\N
482	13	Requested	\N	0	Monthly	Seeded assignment	\N
934	1	Approved	Expert	7	Weekly	Seeded request	\N
546	24	Approved	Beginner	\N	Monthly	Seeded assignment	2025-11-10 12:58:27.264874
619	18	Approved	Beginner	0	Daily	Seeded assignment	2025-11-03 22:12:27.264874
948	20	Requested	\N	7	Rarely	Seeded assignment	2025-11-05 02:30:27.264874
32	24	Requested	Beginner	5	\N	Seeded request	\N
84	3	Approved	\N	\N	\N	Seeded assignment	2025-11-21 05:26:27.264874
270	8	Approved	Beginner	\N	Daily	Seeded request	\N
656	21	Requested	\N	\N	\N	Seeded request	2025-11-28 22:55:27.264874
789	17	Approved	Intermediate	1	\N	Seeded assignment	\N
462	17	Approved	Intermediate	5	Weekly	Seeded assignment	\N
430	1	Requested	\N	5	Monthly	Seeded request	2025-11-13 14:50:27.264874
611	11	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
558	22	Approved	\N	8	Weekly	Seeded assignment	\N
404	10	Requested	\N	\N	\N	Seeded assignment	\N
237	18	Approved	Intermediate	5	Rarely	Seeded request	2025-11-13 13:56:27.264874
316	1	Approved	\N	2	\N	Seeded assignment	\N
105	11	Approved	Expert	6	\N	Seeded assignment	\N
169	13	Requested	\N	\N	\N	Seeded assignment	\N
713	3	Requested	\N	9	Weekly	Seeded assignment	2025-11-23 03:18:27.264874
200	20	Approved	\N	1	\N	Seeded request	2025-11-25 03:21:27.264874
682	12	Approved	\N	1	\N	Seeded assignment	2025-11-20 14:52:27.264874
964	1	Requested	Expert	\N	Rarely	Seeded assignment	\N
372	12	Approved	\N	0	Weekly	Seeded assignment	2025-11-25 11:45:27.264874
142	23	Approved	Beginner	5	Weekly	Seeded assignment	2025-11-21 19:24:27.264874
573	5	Approved	\N	10	\N	Seeded assignment	\N
556	10	Approved	Beginner	\N	Daily	Seeded request	\N
895	11	Approved	Beginner	\N	Monthly	Seeded request	\N
548	19	Approved	\N	7	Daily	Seeded assignment	2025-11-03 17:03:27.264874
957	6	Requested	\N	9	Daily	Seeded request	2025-11-28 10:25:27.264874
720	3	Approved	Expert	\N	\N	Seeded assignment	\N
132	1	Requested	\N	\N	Weekly	Seeded assignment	2025-11-30 18:05:27.264874
580	3	Approved	Expert	1	Weekly	Seeded request	\N
325	23	Approved	Intermediate	8	\N	Seeded assignment	\N
543	17	Approved	Intermediate	\N	\N	Seeded request	\N
443	24	Approved	\N	10	Monthly	Seeded request	2025-11-06 05:58:27.264874
339	8	Requested	Advanced	7	\N	Seeded assignment	\N
282	7	Approved	\N	\N	\N	Seeded request	\N
593	21	Approved	Expert	4	\N	Seeded assignment	2025-11-20 05:53:27.264874
741	25	Approved	\N	\N	Rarely	Seeded assignment	2025-11-20 20:05:27.264874
835	22	Approved	\N	\N	Rarely	Seeded request	\N
477	4	Requested	\N	\N	Weekly	Seeded assignment	\N
958	23	Approved	\N	4	Rarely	Seeded request	2025-11-03 12:00:27.264874
50	9	Requested	Advanced	\N	Daily	Seeded request	2025-11-28 09:12:27.264874
49	20	Requested	\N	\N	\N	Seeded request	\N
539	11	Requested	Expert	\N	Rarely	Seeded request	\N
725	21	Approved	Expert	5	Weekly	Seeded request	2025-12-01 02:11:27.264874
889	24	Requested	Advanced	\N	Rarely	Seeded assignment	\N
219	16	Approved	\N	\N	Weekly	Seeded request	\N
616	5	Requested	Beginner	10	Daily	Seeded assignment	2025-11-12 23:16:27.264874
224	9	Requested	Advanced	\N	Rarely	Seeded request	\N
394	1	Requested	\N	\N	Monthly	Seeded assignment	2025-11-17 05:31:27.264874
970	10	Approved	\N	4	\N	Seeded request	\N
109	7	Requested	Beginner	\N	\N	Seeded request	2025-11-30 22:38:27.264874
600	24	Approved	Expert	7	Monthly	Seeded assignment	\N
682	20	Approved	\N	\N	\N	Seeded assignment	\N
954	24	Approved	\N	4	Weekly	Seeded request	\N
532	25	Requested	\N	\N	Rarely	Seeded request	2025-11-21 21:37:27.264874
651	17	Approved	Beginner	2	\N	Seeded assignment	\N
365	25	Requested	Expert	5	Rarely	Seeded request	2025-11-12 09:22:27.264874
788	3	Approved	\N	\N	Rarely	Seeded assignment	2025-11-06 11:46:27.264874
590	10	Approved	Advanced	10	\N	Seeded request	2025-11-11 12:24:27.264874
7	13	Approved	Intermediate	3	Weekly	Seeded assignment	\N
128	21	Requested	Intermediate	9	Rarely	Seeded request	2025-11-04 07:47:27.264874
440	24	Requested	\N	10	\N	Seeded request	\N
263	13	Approved	Expert	10	Daily	Seeded assignment	\N
366	24	Approved	\N	5	\N	Seeded request	\N
852	6	Approved	Advanced	\N	\N	Seeded request	\N
897	25	Requested	Beginner	\N	\N	Seeded request	\N
946	10	Approved	Beginner	1	Weekly	Seeded assignment	\N
51	9	Approved	\N	8	Weekly	Seeded request	2025-11-30 03:19:27.264874
218	8	Approved	Intermediate	7	\N	Seeded assignment	2025-11-05 23:48:27.264874
968	3	Approved	\N	\N	Daily	Seeded request	2025-12-01 21:37:27.264874
44	18	Requested	Intermediate	\N	\N	Seeded request	\N
88	5	Requested	Beginner	7	\N	Seeded assignment	\N
282	23	Requested	Beginner	\N	\N	Seeded assignment	\N
666	20	Requested	Intermediate	9	\N	Seeded assignment	\N
1	20	Requested	\N	2	\N	Seeded request	2025-11-16 03:22:27.264874
325	7	Requested	Advanced	8	Daily	Seeded request	2025-11-27 06:54:27.264874
913	24	Requested	Advanced	2	\N	Seeded assignment	2025-11-13 03:02:27.264874
715	4	Approved	Expert	\N	\N	Seeded assignment	2025-12-01 01:19:27.264874
938	17	Requested	Expert	5	\N	Seeded request	2025-11-25 00:12:27.264874
698	1	Approved	Advanced	\N	\N	Seeded request	2025-11-04 15:44:27.264874
371	12	Approved	Expert	8	Monthly	Seeded request	\N
513	9	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-05 22:31:27.264874
141	1	Approved	\N	1	\N	Seeded request	2025-11-17 15:22:27.264874
481	4	Requested	Intermediate	5	Monthly	Seeded assignment	\N
9	5	Requested	Advanced	\N	Rarely	Seeded request	\N
488	4	Approved	Expert	\N	Monthly	Seeded request	2025-12-01 19:24:27.264874
527	13	Requested	Expert	9	Rarely	Seeded request	\N
773	13	Approved	\N	2	\N	Seeded assignment	\N
411	5	Approved	Intermediate	2	Monthly	Seeded assignment	\N
311	18	Approved	\N	4	Daily	Seeded assignment	\N
245	20	Approved	\N	9	Rarely	Seeded assignment	\N
727	10	Requested	Expert	8	Monthly	Seeded assignment	2025-11-05 13:21:27.264874
798	5	Approved	Expert	9	Rarely	Seeded assignment	2025-11-27 12:02:27.264874
294	11	Approved	Beginner	1	Monthly	Seeded assignment	\N
380	12	Approved	\N	\N	Weekly	Seeded request	\N
327	20	Approved	\N	6	\N	Seeded request	\N
90	1	Approved	Advanced	\N	\N	Seeded assignment	\N
161	19	Approved	Advanced	\N	\N	Seeded assignment	\N
490	5	Requested	Intermediate	4	\N	Seeded request	\N
297	10	Requested	\N	\N	Weekly	Seeded assignment	\N
984	17	Approved	Intermediate	2	Monthly	Seeded assignment	\N
257	11	Requested	\N	2	\N	Seeded assignment	\N
781	10	Approved	\N	3	Monthly	Seeded request	\N
138	12	Approved	\N	\N	\N	Seeded request	\N
492	21	Approved	Intermediate	1	\N	Seeded assignment	\N
972	5	Approved	\N	5	\N	Seeded request	\N
441	22	Approved	\N	9	\N	Seeded request	\N
766	18	Approved	Intermediate	\N	Weekly	Seeded request	\N
393	22	Requested	Advanced	\N	Rarely	Seeded assignment	\N
326	21	Approved	Advanced	\N	\N	Seeded assignment	2025-12-02 22:04:27.264874
574	12	Requested	Expert	\N	Daily	Seeded assignment	2025-11-14 01:12:27.264874
893	10	Approved	Expert	\N	\N	Seeded assignment	2025-11-18 02:48:27.264874
116	22	Approved	Expert	4	\N	Seeded request	2025-11-06 13:05:27.264874
671	20	Approved	\N	6	Weekly	Seeded assignment	2025-11-19 03:50:27.264874
851	17	Requested	Expert	\N	Monthly	Seeded assignment	\N
83	17	Approved	Beginner	\N	Daily	Seeded request	2025-11-27 03:43:27.264874
226	25	Requested	Advanced	\N	Daily	Seeded assignment	2025-11-16 06:31:27.264874
474	17	Requested	Beginner	2	Daily	Seeded assignment	\N
421	21	Requested	Expert	8	\N	Seeded assignment	2025-11-08 11:48:27.264874
598	19	Requested	\N	\N	Monthly	Seeded assignment	\N
112	24	Approved	Intermediate	9	\N	Seeded assignment	\N
734	22	Approved	Beginner	\N	\N	Seeded assignment	\N
936	11	Approved	Advanced	1	Daily	Seeded assignment	2025-11-06 04:21:27.264874
500	25	Requested	Expert	8	Monthly	Seeded assignment	\N
316	9	Approved	Expert	10	Daily	Seeded assignment	2025-11-03 08:30:27.264874
115	18	Approved	Expert	2	Rarely	Seeded assignment	\N
472	19	Approved	Beginner	\N	Daily	Seeded request	\N
560	3	Requested	Beginner	\N	Daily	Seeded assignment	2025-11-19 11:39:27.264874
717	9	Approved	Intermediate	\N	Monthly	Seeded request	\N
832	12	Requested	\N	3	Rarely	Seeded assignment	2025-11-11 14:57:27.264874
107	25	Approved	\N	10	\N	Seeded request	\N
8	16	Approved	Intermediate	2	Daily	Seeded assignment	2025-11-22 21:07:27.264874
988	3	Approved	Beginner	\N	Monthly	Seeded request	2025-11-18 18:22:27.264874
356	22	Approved	\N	\N	\N	Seeded assignment	2025-11-22 19:16:27.264874
61	20	Approved	Advanced	10	\N	Seeded assignment	\N
493	25	Requested	Intermediate	\N	Monthly	Seeded request	2025-11-23 05:52:27.264874
732	1	Requested	\N	0	Monthly	Seeded request	2025-11-20 20:49:27.264874
774	8	Requested	\N	\N	Monthly	Seeded assignment	2025-11-18 08:27:27.264874
948	5	Approved	Advanced	\N	\N	Seeded assignment	\N
291	20	Approved	\N	7	Daily	Seeded request	\N
111	19	Approved	Advanced	\N	\N	Seeded request	\N
775	25	Approved	Expert	\N	\N	Seeded assignment	2025-11-25 09:57:27.264874
496	23	Requested	Intermediate	8	\N	Seeded assignment	2025-11-18 02:10:27.264874
864	20	Requested	Beginner	\N	\N	Seeded assignment	\N
299	1	Approved	\N	8	Weekly	Seeded assignment	\N
72	6	Requested	Intermediate	\N	\N	Seeded request	\N
283	18	Requested	\N	2	Daily	Seeded assignment	\N
150	11	Approved	Expert	8	\N	Seeded assignment	2025-11-10 01:14:27.264874
899	7	Approved	\N	7	\N	Seeded assignment	\N
926	11	Approved	Expert	\N	Daily	Seeded assignment	\N
631	21	Approved	\N	0	Rarely	Seeded request	2025-11-05 06:34:27.264874
19	25	Approved	Beginner	\N	\N	Seeded assignment	\N
398	25	Approved	Expert	\N	Daily	Seeded assignment	2025-11-10 17:39:27.264874
449	7	Approved	\N	8	Rarely	Seeded request	\N
573	20	Approved	\N	5	Rarely	Seeded assignment	\N
966	25	Approved	Intermediate	2	Daily	Seeded assignment	\N
326	17	Approved	\N	\N	Rarely	Seeded assignment	\N
751	22	Requested	Intermediate	\N	\N	Seeded assignment	\N
305	4	Approved	Advanced	\N	Weekly	Seeded assignment	\N
453	12	Approved	Beginner	6	\N	Seeded request	\N
799	9	Approved	Beginner	9	Daily	Seeded assignment	2025-11-05 10:47:27.264874
697	3	Requested	\N	\N	\N	Seeded request	\N
80	4	Requested	Intermediate	\N	Daily	Seeded request	\N
940	3	Requested	Expert	1	Weekly	Seeded assignment	\N
744	1	Approved	\N	0	Rarely	Seeded assignment	2025-11-17 19:13:27.264874
678	5	Approved	Intermediate	\N	Daily	Seeded request	\N
28	16	Approved	Advanced	\N	\N	Seeded request	\N
250	6	Approved	\N	5	\N	Seeded assignment	\N
710	3	Requested	\N	8	Weekly	Seeded request	\N
561	19	Approved	Beginner	0	Rarely	Seeded assignment	2025-11-17 07:37:27.264874
136	7	Approved	\N	9	\N	Seeded request	2025-11-15 22:42:27.264874
585	16	Approved	Advanced	\N	Daily	Seeded request	2025-11-22 03:34:27.264874
757	18	Approved	Intermediate	\N	Rarely	Seeded assignment	2025-11-06 21:08:27.264874
179	1	Requested	\N	\N	Monthly	Seeded request	2025-11-29 03:22:27.264874
412	21	Requested	\N	\N	\N	Seeded request	\N
491	18	Approved	\N	0	\N	Seeded request	\N
907	18	Approved	\N	3	Rarely	Seeded request	2025-11-21 11:21:27.264874
566	24	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
875	10	Approved	Intermediate	\N	Weekly	Seeded assignment	2025-11-07 09:28:27.264874
170	17	Requested	Expert	\N	Rarely	Seeded request	\N
945	19	Requested	Expert	0	Monthly	Seeded assignment	\N
345	18	Approved	\N	7	Weekly	Seeded assignment	\N
416	10	Approved	Intermediate	\N	Daily	Seeded request	2025-11-16 20:26:27.264874
762	16	Approved	\N	10	\N	Seeded assignment	\N
758	10	Requested	\N	3	Monthly	Seeded assignment	\N
931	25	Approved	Advanced	1	Weekly	Seeded assignment	\N
443	10	Requested	\N	10	\N	Seeded assignment	\N
808	12	Requested	Advanced	7	Weekly	Seeded assignment	2025-11-10 21:18:27.264874
938	21	Approved	Expert	\N	Weekly	Seeded assignment	2025-11-24 04:30:27.264874
673	25	Approved	Beginner	0	Rarely	Seeded assignment	2025-11-27 10:28:27.264874
459	21	Requested	\N	8	Weekly	Seeded assignment	\N
436	18	Approved	Expert	0	Daily	Seeded assignment	2025-11-14 15:26:27.264874
959	1	Requested	\N	\N	Weekly	Seeded assignment	\N
347	5	Requested	Advanced	\N	\N	Seeded assignment	2025-11-30 20:52:27.264874
841	21	Approved	Beginner	\N	\N	Seeded request	\N
96	25	Approved	Beginner	1	Monthly	Seeded request	\N
798	12	Requested	\N	\N	Weekly	Seeded assignment	\N
128	17	Requested	Advanced	9	\N	Seeded assignment	2025-12-03 00:25:27.264874
917	18	Requested	Advanced	\N	Daily	Seeded assignment	2025-11-26 14:16:27.264874
25	7	Requested	Expert	\N	Daily	Seeded assignment	2025-11-28 17:20:27.264874
24	10	Requested	Beginner	\N	\N	Seeded request	\N
445	12	Approved	\N	2	Rarely	Seeded assignment	2025-11-22 20:57:27.264874
571	22	Approved	\N	6	Weekly	Seeded assignment	\N
411	12	Approved	Expert	9	Weekly	Seeded assignment	\N
855	22	Requested	Beginner	7	Daily	Seeded assignment	\N
162	4	Requested	Advanced	\N	\N	Seeded assignment	2025-11-16 16:12:27.264874
402	5	Requested	Beginner	0	Weekly	Seeded request	\N
370	1	Requested	\N	\N	Weekly	Seeded assignment	\N
697	4	Requested	\N	4	\N	Seeded request	\N
954	10	Requested	\N	\N	Daily	Seeded assignment	\N
288	6	Requested	Expert	10	Daily	Seeded assignment	2025-11-07 11:05:27.264874
846	17	Requested	Intermediate	3	\N	Seeded assignment	2025-11-12 17:36:27.264874
80	3	Approved	\N	7	Weekly	Seeded request	\N
115	19	Approved	\N	\N	Daily	Seeded assignment	\N
472	18	Approved	Beginner	9	Weekly	Seeded request	2025-11-22 12:41:27.264874
9	20	Requested	\N	1	\N	Seeded request	2025-11-13 20:20:27.264874
10	8	Requested	Beginner	5	Weekly	Seeded request	\N
747	11	Approved	Beginner	2	Rarely	Seeded assignment	2025-11-25 18:25:27.264874
318	3	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-10 07:06:27.264874
322	19	Requested	\N	0	Monthly	Seeded assignment	\N
495	13	Requested	Beginner	\N	Daily	Seeded assignment	2025-11-13 09:39:27.264874
680	19	Approved	Beginner	3	Monthly	Seeded assignment	2025-11-03 15:13:27.264874
490	20	Approved	\N	4	Rarely	Seeded request	\N
950	1	Approved	\N	\N	Daily	Seeded assignment	2025-11-12 23:05:27.264874
66	6	Requested	Advanced	\N	\N	Seeded assignment	\N
114	22	Requested	Expert	\N	\N	Seeded assignment	\N
340	17	Approved	Intermediate	5	\N	Seeded assignment	\N
487	16	Approved	\N	6	Rarely	Seeded request	\N
853	8	Approved	\N	9	\N	Seeded assignment	2025-11-07 16:38:27.264874
127	9	Requested	Advanced	5	\N	Seeded request	\N
157	12	Approved	Expert	6	Rarely	Seeded assignment	\N
702	22	Approved	Expert	7	\N	Seeded assignment	\N
522	11	Requested	\N	0	\N	Seeded request	2025-11-03 07:15:27.264874
913	10	Approved	\N	\N	Monthly	Seeded request	\N
359	23	Approved	Intermediate	7	Daily	Seeded request	\N
123	24	Approved	\N	4	Rarely	Seeded assignment	2025-11-11 11:08:27.264874
389	22	Requested	Beginner	8	\N	Seeded assignment	\N
201	11	Requested	\N	\N	Rarely	Seeded request	\N
503	12	Approved	Beginner	3	\N	Seeded request	\N
691	22	Requested	Expert	\N	Rarely	Seeded assignment	\N
590	24	Approved	Beginner	3	\N	Seeded assignment	\N
440	10	Requested	\N	\N	Rarely	Seeded assignment	\N
25	23	Requested	\N	10	Weekly	Seeded assignment	2025-11-12 08:46:27.264874
220	18	Approved	Advanced	\N	\N	Seeded request	2025-11-06 12:15:27.264874
439	1	Approved	Expert	\N	\N	Seeded request	\N
599	7	Requested	\N	7	\N	Seeded request	\N
551	9	Approved	\N	\N	Daily	Seeded assignment	\N
14	11	Approved	\N	\N	\N	Seeded assignment	\N
276	7	Approved	\N	8	Monthly	Seeded request	\N
706	23	Approved	Beginner	\N	Daily	Seeded request	\N
886	24	Requested	Intermediate	6	\N	Seeded assignment	2025-11-08 04:23:27.264874
639	4	Approved	Beginner	9	Daily	Seeded request	\N
704	25	Approved	\N	4	\N	Seeded request	\N
859	11	Approved	Beginner	1	Weekly	Seeded request	\N
187	4	Approved	Advanced	7	\N	Seeded request	\N
337	24	Approved	Beginner	3	Daily	Seeded request	\N
446	16	Approved	Advanced	4	Daily	Seeded assignment	\N
362	3	Requested	\N	2	Daily	Seeded request	\N
92	19	Approved	Advanced	9	Daily	Seeded assignment	2025-11-29 18:33:27.264874
662	6	Approved	Beginner	6	Monthly	Seeded assignment	\N
533	8	Approved	Intermediate	\N	\N	Seeded request	\N
390	3	Requested	Intermediate	\N	Daily	Seeded assignment	\N
961	16	Requested	\N	3	\N	Seeded assignment	2025-11-17 15:43:27.264874
864	12	Requested	Intermediate	9	Weekly	Seeded request	\N
811	4	Requested	Expert	7	\N	Seeded request	\N
135	6	Requested	\N	2	\N	Seeded assignment	\N
112	10	Approved	Expert	2	Monthly	Seeded assignment	\N
343	8	Approved	Expert	\N	\N	Seeded assignment	\N
937	17	Approved	\N	6	Daily	Seeded request	\N
414	23	Approved	Intermediate	9	Monthly	Seeded request	\N
291	12	Approved	\N	7	\N	Seeded assignment	\N
604	16	Approved	\N	6	Weekly	Seeded assignment	\N
39	6	Requested	\N	7	\N	Seeded request	\N
86	13	Requested	\N	\N	\N	Seeded assignment	\N
423	12	Requested	Advanced	\N	Rarely	Seeded request	2025-11-28 04:17:27.264874
690	10	Approved	\N	2	Monthly	Seeded assignment	\N
1	5	Approved	\N	1	\N	Seeded assignment	\N
797	12	Requested	Expert	\N	\N	Seeded request	\N
88	20	Approved	\N	8	\N	Seeded assignment	2025-11-10 10:13:27.264874
158	25	Approved	\N	\N	\N	Seeded assignment	\N
605	4	Approved	Intermediate	9	Daily	Seeded assignment	\N
186	8	Requested	Intermediate	\N	Daily	Seeded request	2025-11-25 04:37:27.264874
959	9	Requested	Expert	\N	Rarely	Seeded request	\N
708	22	Approved	Beginner	0	Monthly	Seeded request	2025-11-20 00:10:27.264874
689	24	Approved	\N	\N	Daily	Seeded assignment	2025-11-17 20:24:27.264874
795	1	Approved	\N	6	Monthly	Seeded request	2025-11-24 00:57:27.264874
460	21	Approved	Advanced	\N	Monthly	Seeded assignment	\N
227	8	Requested	Beginner	\N	Rarely	Seeded request	\N
144	7	Requested	\N	8	\N	Seeded request	\N
617	19	Approved	\N	\N	Weekly	Seeded request	\N
740	7	Approved	\N	7	\N	Seeded assignment	2025-11-09 07:30:27.264874
980	13	Approved	\N	1	\N	Seeded assignment	\N
244	9	Approved	\N	8	Weekly	Seeded request	\N
446	10	Requested	Advanced	6	\N	Seeded assignment	2025-11-08 07:51:27.264874
935	22	Approved	\N	5	\N	Seeded assignment	\N
786	18	Approved	Intermediate	2	\N	Seeded assignment	\N
957	11	Approved	\N	4	\N	Seeded assignment	2025-11-24 09:35:27.264874
863	4	Approved	\N	2	Daily	Seeded request	\N
265	11	Approved	\N	4	\N	Seeded request	\N
746	23	Requested	Beginner	8	Weekly	Seeded assignment	\N
414	18	Requested	Advanced	\N	\N	Seeded assignment	\N
576	1	Requested	Expert	\N	Daily	Seeded assignment	2025-11-07 08:36:27.264874
235	24	Requested	Beginner	0	\N	Seeded request	2025-11-24 15:31:27.264874
105	6	Approved	Intermediate	7	\N	Seeded request	\N
655	19	Approved	\N	9	Rarely	Seeded request	\N
818	22	Approved	Expert	\N	Weekly	Seeded request	2025-11-10 18:47:27.264874
909	6	Approved	Expert	2	\N	Seeded request	\N
396	22	Approved	Beginner	1	Daily	Seeded assignment	\N
403	9	Requested	\N	2	Daily	Seeded request	\N
548	7	Approved	Intermediate	6	Monthly	Seeded assignment	\N
112	16	Requested	\N	2	\N	Seeded assignment	\N
149	18	Approved	Advanced	\N	\N	Seeded assignment	\N
329	25	Approved	Advanced	\N	\N	Seeded assignment	2025-12-01 19:23:27.264874
759	1	Requested	Advanced	10	Weekly	Seeded request	\N
54	8	Approved	Beginner	\N	\N	Seeded assignment	2025-11-11 01:23:27.264874
232	3	Requested	Intermediate	2	\N	Seeded request	\N
97	10	Requested	\N	2	\N	Seeded request	\N
563	5	Approved	Intermediate	5	Rarely	Seeded assignment	2025-11-20 23:27:27.264874
130	7	Approved	Intermediate	0	Monthly	Seeded assignment	\N
127	25	Approved	\N	9	\N	Seeded assignment	\N
749	7	Requested	\N	10	\N	Seeded request	2025-11-28 23:56:27.264874
225	6	Approved	Advanced	2	Daily	Seeded assignment	\N
760	6	Requested	\N	10	\N	Seeded assignment	2025-11-14 04:35:27.264874
709	17	Requested	Intermediate	9	\N	Seeded request	\N
892	3	Approved	\N	3	\N	Seeded assignment	\N
395	21	Approved	\N	0	Weekly	Seeded assignment	\N
681	20	Approved	Intermediate	2	Weekly	Seeded request	2025-11-05 15:56:27.264874
691	17	Requested	Intermediate	1	Rarely	Seeded assignment	\N
600	16	Requested	Beginner	0	Daily	Seeded assignment	2025-11-16 23:24:27.264874
711	7	Requested	Advanced	8	\N	Seeded assignment	\N
917	7	Approved	\N	8	Rarely	Seeded request	\N
744	25	Approved	Beginner	8	Daily	Seeded assignment	\N
768	6	Approved	Intermediate	\N	Monthly	Seeded request	\N
954	16	Approved	\N	0	\N	Seeded assignment	2025-11-08 23:47:27.264874
704	9	Approved	Expert	8	\N	Seeded assignment	2025-11-20 07:22:27.264874
978	6	Approved	\N	8	Monthly	Seeded assignment	2025-11-08 16:20:27.264874
238	11	Requested	Advanced	4	Daily	Seeded assignment	\N
20	20	Requested	Expert	3	\N	Seeded assignment	\N
389	17	Requested	Beginner	8	\N	Seeded request	\N
661	22	Requested	Advanced	\N	\N	Seeded assignment	\N
205	17	Requested	\N	7	Weekly	Seeded assignment	2025-11-18 15:36:27.264874
392	1	Requested	\N	9	Weekly	Seeded assignment	2025-11-11 00:05:27.264874
508	5	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-11 17:33:27.264874
641	17	Requested	\N	3	Rarely	Seeded assignment	2025-11-23 03:20:27.264874
65	4	Requested	Expert	\N	Weekly	Seeded request	\N
882	5	Requested	Advanced	1	Rarely	Seeded request	2025-11-05 21:40:27.264874
436	7	Requested	\N	1	\N	Seeded request	\N
551	25	Approved	Expert	3	Rarely	Seeded assignment	\N
219	24	Requested	\N	10	Monthly	Seeded assignment	\N
340	22	Requested	Intermediate	\N	Rarely	Seeded request	\N
652	3	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
620	20	Approved	Intermediate	2	Weekly	Seeded assignment	\N
202	3	Approved	\N	\N	Weekly	Seeded request	\N
269	21	Approved	\N	8	Rarely	Seeded assignment	\N
700	20	Requested	Beginner	10	\N	Seeded assignment	2025-11-06 18:28:27.264874
589	16	Approved	\N	\N	\N	Seeded request	\N
913	16	Requested	\N	\N	Monthly	Seeded assignment	\N
413	19	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-05 13:32:27.264874
959	25	Requested	\N	\N	Weekly	Seeded assignment	2025-11-04 02:06:27.264874
266	3	Approved	\N	\N	\N	Seeded assignment	\N
931	1	Approved	Beginner	10	Monthly	Seeded request	2025-11-17 02:44:27.264874
638	9	Approved	Intermediate	\N	Daily	Seeded request	\N
254	22	Approved	\N	7	Daily	Seeded request	2025-11-29 08:10:27.264874
559	13	Approved	Expert	3	\N	Seeded assignment	\N
833	5	Approved	\N	6	\N	Seeded assignment	2025-11-16 23:30:27.264874
592	7	Requested	\N	9	Daily	Seeded request	2025-11-25 21:36:27.264874
440	16	Approved	Intermediate	9	\N	Seeded request	\N
754	6	Approved	\N	5	Rarely	Seeded assignment	2025-11-08 10:06:27.264874
884	23	Requested	Expert	0	Monthly	Seeded request	\N
530	4	Requested	Beginner	\N	Weekly	Seeded assignment	2025-11-30 15:28:27.264874
163	13	Approved	Intermediate	10	Weekly	Seeded assignment	2025-11-07 21:02:27.264874
657	7	Requested	Expert	4	\N	Seeded assignment	2025-11-07 09:03:27.264874
917	23	Requested	Intermediate	\N	Rarely	Seeded request	\N
403	1	Requested	\N	2	\N	Seeded assignment	2025-11-21 21:54:27.264874
583	6	Approved	Expert	9	Monthly	Seeded assignment	\N
650	6	Approved	Beginner	5	\N	Seeded assignment	\N
120	11	Approved	Beginner	6	\N	Seeded assignment	2025-11-22 18:42:27.264874
313	10	Approved	Intermediate	1	\N	Seeded request	\N
85	16	Requested	Beginner	\N	\N	Seeded request	2025-11-20 00:28:27.264874
568	6	Approved	\N	3	\N	Seeded assignment	\N
30	10	Requested	Intermediate	\N	Weekly	Seeded assignment	2025-11-05 15:13:27.264874
290	8	Approved	Intermediate	10	\N	Seeded request	\N
292	20	Requested	\N	1	Weekly	Seeded assignment	\N
420	23	Requested	\N	5	\N	Seeded request	\N
113	4	Requested	Beginner	3	Weekly	Seeded assignment	2025-12-02 11:53:27.264874
384	12	Approved	\N	\N	Weekly	Seeded assignment	\N
493	9	Approved	\N	7	\N	Seeded assignment	\N
956	13	Requested	Advanced	\N	\N	Seeded assignment	\N
622	17	Approved	Advanced	0	Weekly	Seeded request	\N
820	9	Approved	\N	6	Monthly	Seeded assignment	\N
55	22	Requested	\N	5	\N	Seeded request	\N
232	4	Approved	\N	6	Rarely	Seeded request	\N
916	7	Approved	Advanced	\N	Weekly	Seeded assignment	2025-11-18 05:20:27.264874
613	6	Approved	Intermediate	6	Rarely	Seeded assignment	2025-11-26 03:15:27.264874
803	4	Approved	\N	\N	Monthly	Seeded request	\N
911	7	Requested	\N	\N	Monthly	Seeded assignment	2025-11-07 04:45:27.264874
826	24	Approved	Beginner	\N	Daily	Seeded request	2025-11-09 03:56:27.264874
416	16	Requested	\N	\N	\N	Seeded request	\N
762	10	Requested	\N	7	\N	Seeded assignment	2025-11-27 20:57:27.264874
129	17	Requested	Expert	6	Weekly	Seeded request	2025-11-16 21:03:27.264874
214	12	Requested	\N	9	Daily	Seeded assignment	\N
437	18	Approved	\N	\N	Monthly	Seeded assignment	\N
863	3	Approved	Intermediate	9	\N	Seeded request	\N
137	20	Requested	Expert	6	Daily	Seeded request	\N
343	13	Approved	Intermediate	0	Monthly	Seeded assignment	\N
592	23	Approved	\N	4	\N	Seeded assignment	\N
397	12	Approved	\N	8	\N	Seeded request	\N
941	4	Approved	Advanced	3	Rarely	Seeded assignment	\N
665	11	Requested	Advanced	6	\N	Seeded request	\N
330	12	Approved	\N	1	\N	Seeded request	2025-11-29 20:09:27.264874
903	17	Approved	Expert	\N	\N	Seeded assignment	\N
628	10	Approved	Advanced	1	Monthly	Seeded assignment	2025-11-17 22:05:27.264874
862	21	Approved	Beginner	4	\N	Seeded assignment	\N
759	9	Requested	Advanced	8	\N	Seeded request	\N
807	11	Approved	\N	9	\N	Seeded assignment	\N
285	12	Requested	Beginner	10	Monthly	Seeded request	\N
615	23	Approved	Beginner	5	Weekly	Seeded request	\N
888	6	Requested	Advanced	7	Rarely	Seeded assignment	2025-11-14 23:07:27.264874
918	5	Approved	\N	1	Rarely	Seeded assignment	2025-12-02 09:39:27.264874
106	12	Requested	\N	\N	Rarely	Seeded request	\N
146	13	Approved	Beginner	\N	Daily	Seeded request	2025-11-14 22:40:27.264874
454	17	Requested	Beginner	\N	Rarely	Seeded assignment	\N
483	10	Approved	\N	\N	\N	Seeded request	2025-11-29 18:18:27.264874
8	10	Requested	\N	0	\N	Seeded assignment	2025-11-13 15:47:27.264874
116	21	Requested	\N	9	Weekly	Seeded request	2025-11-21 12:07:27.264874
653	3	Requested	Intermediate	\N	Monthly	Seeded request	\N
431	7	Requested	Advanced	8	Daily	Seeded request	\N
266	4	Approved	Advanced	\N	\N	Seeded request	\N
399	11	Approved	\N	3	Daily	Seeded assignment	\N
865	4	Approved	\N	8	Monthly	Seeded assignment	\N
382	20	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-24 02:14:27.264874
497	12	Requested	Beginner	2	\N	Seeded request	2025-11-13 16:24:27.264874
164	1	Approved	Advanced	\N	Monthly	Seeded request	\N
816	19	Requested	Intermediate	2	\N	Seeded request	2025-11-17 00:31:27.264874
728	16	Approved	\N	4	Rarely	Seeded assignment	2025-11-03 09:40:27.264874
438	25	Approved	\N	6	Rarely	Seeded assignment	\N
542	10	Approved	Intermediate	\N	Daily	Seeded assignment	\N
772	23	Approved	Beginner	\N	Rarely	Seeded request	2025-11-14 21:40:27.264874
68	4	Approved	Advanced	\N	Daily	Seeded assignment	\N
861	19	Approved	Beginner	\N	Monthly	Seeded assignment	2025-11-05 12:48:27.264874
65	3	Approved	Intermediate	5	Rarely	Seeded request	2025-11-21 08:49:27.264874
142	19	Approved	\N	\N	Weekly	Seeded assignment	\N
638	1	Requested	\N	\N	Rarely	Seeded assignment	2025-12-01 06:39:27.264874
166	7	Requested	Intermediate	10	\N	Seeded assignment	\N
724	24	Requested	Beginner	\N	\N	Seeded assignment	2025-11-09 13:38:27.264874
883	20	Approved	Intermediate	10	Daily	Seeded request	\N
324	5	Approved	Expert	\N	Weekly	Seeded request	\N
369	24	Approved	Intermediate	6	\N	Seeded request	2025-11-17 13:11:27.264874
241	19	Requested	\N	2	\N	Seeded assignment	2025-11-16 20:24:27.264874
357	19	Approved	Intermediate	10	\N	Seeded assignment	\N
928	4	Requested	\N	\N	Daily	Seeded assignment	2025-12-02 03:03:27.264874
158	1	Requested	Intermediate	4	Weekly	Seeded request	\N
81	21	Approved	Advanced	0	\N	Seeded request	2025-11-08 12:43:27.264874
243	13	Approved	Intermediate	\N	Rarely	Seeded assignment	\N
492	22	Approved	Beginner	2	Weekly	Seeded assignment	2025-11-10 20:27:27.264874
220	7	Approved	Beginner	\N	\N	Seeded request	\N
393	21	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-28 03:35:27.264874
648	6	Approved	Intermediate	0	Rarely	Seeded assignment	2025-11-27 23:33:27.264874
749	23	Approved	Beginner	10	Weekly	Seeded request	\N
931	9	Approved	Beginner	9	\N	Seeded assignment	2025-11-11 12:01:27.264874
577	12	Requested	\N	4	\N	Seeded request	\N
673	9	Approved	Beginner	\N	\N	Seeded request	2025-11-30 22:06:27.264874
336	24	Approved	Beginner	\N	\N	Seeded assignment	\N
441	21	Approved	Advanced	8	Weekly	Seeded assignment	\N
276	18	Requested	\N	\N	Daily	Seeded request	\N
425	8	Requested	Advanced	\N	Weekly	Seeded assignment	\N
309	25	Requested	Intermediate	2	Weekly	Seeded request	\N
216	16	Approved	Advanced	8	\N	Seeded request	\N
836	11	Approved	\N	\N	\N	Seeded assignment	2025-11-26 00:23:27.264874
778	21	Requested	Beginner	6	Monthly	Seeded request	\N
621	17	Requested	\N	\N	Daily	Seeded assignment	\N
532	9	Approved	\N	8	\N	Seeded request	\N
365	9	Approved	\N	10	Daily	Seeded request	\N
631	22	Requested	Intermediate	3	\N	Seeded assignment	\N
727	16	Requested	Intermediate	\N	Monthly	Seeded assignment	\N
189	3	Requested	Expert	9	Rarely	Seeded assignment	2025-11-10 08:28:27.264874
229	7	Requested	Beginner	\N	Monthly	Seeded request	\N
47	4	Approved	\N	10	Rarely	Seeded request	2025-11-21 05:39:27.264874
119	13	Approved	Expert	4	\N	Seeded request	2025-11-25 02:31:27.264874
43	8	Approved	\N	5	Daily	Seeded assignment	2025-12-01 21:17:27.264874
595	4	Requested	\N	1	Rarely	Seeded request	\N
561	7	Requested	\N	1	Monthly	Seeded request	\N
921	13	Requested	\N	0	Daily	Seeded request	2025-11-27 13:38:27.264874
949	11	Approved	\N	1	\N	Seeded request	\N
361	1	Approved	Advanced	3	\N	Seeded request	2025-11-08 02:08:27.264874
474	22	Approved	\N	3	Weekly	Seeded assignment	\N
478	18	Requested	Intermediate	9	Rarely	Seeded request	2025-11-05 18:52:27.264874
505	11	Approved	\N	6	Weekly	Seeded request	\N
397	5	Approved	Advanced	10	Daily	Seeded request	2025-11-22 08:20:27.264874
636	4	Requested	Advanced	2	Daily	Seeded request	2025-11-10 16:01:27.264874
387	10	Approved	\N	5	Daily	Seeded request	\N
705	16	Requested	\N	\N	\N	Seeded assignment	2025-11-13 12:15:27.264874
703	25	Approved	Advanced	2	Monthly	Seeded assignment	2025-11-05 16:19:27.264874
851	22	Requested	Advanced	\N	Daily	Seeded assignment	\N
214	5	Approved	Intermediate	5	Weekly	Seeded request	\N
139	11	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
756	13	Requested	\N	3	Weekly	Seeded assignment	2025-11-19 10:18:27.264874
663	23	Requested	Expert	\N	Weekly	Seeded request	2025-12-02 19:15:27.264874
831	24	Approved	\N	3	\N	Seeded request	2025-11-15 21:57:27.264874
735	25	Approved	Expert	\N	\N	Seeded assignment	\N
925	6	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-24 13:23:27.264874
680	23	Approved	\N	\N	Rarely	Seeded assignment	\N
136	19	Approved	Expert	3	Rarely	Seeded request	\N
454	21	Approved	Intermediate	4	Weekly	Seeded request	2025-11-27 11:05:27.264874
924	8	Requested	\N	8	Weekly	Seeded request	2025-11-17 22:37:27.264874
461	9	Requested	Intermediate	5	\N	Seeded assignment	\N
819	16	Approved	Expert	7	Weekly	Seeded assignment	\N
466	11	Approved	\N	5	Monthly	Seeded assignment	\N
385	17	Requested	\N	\N	Weekly	Seeded assignment	2025-11-03 20:08:27.264874
315	12	Approved	\N	\N	\N	Seeded request	\N
376	3	Approved	Intermediate	\N	Monthly	Seeded assignment	2025-11-04 07:14:27.264874
339	13	Requested	Advanced	\N	\N	Seeded request	\N
400	16	Approved	\N	\N	Daily	Seeded request	\N
356	21	Requested	Intermediate	6	Monthly	Seeded request	\N
71	18	Requested	\N	4	\N	Seeded assignment	\N
261	1	Requested	\N	1	Weekly	Seeded request	\N
927	11	Approved	Advanced	9	Monthly	Seeded request	\N
815	20	Requested	\N	7	\N	Seeded assignment	2025-11-19 05:51:27.264874
897	9	Requested	Beginner	\N	\N	Seeded assignment	2025-11-03 16:37:27.264874
97	24	Approved	Expert	5	Daily	Seeded assignment	\N
976	9	Approved	\N	0	\N	Seeded request	\N
823	18	Approved	Intermediate	6	Rarely	Seeded assignment	2025-11-04 16:40:27.264874
908	6	Requested	Intermediate	6	Monthly	Seeded request	2025-11-23 07:53:27.264874
780	7	Approved	\N	\N	\N	Seeded assignment	2025-11-19 01:06:27.264874
204	21	Requested	Advanced	7	Daily	Seeded assignment	2025-11-09 01:45:27.264874
332	1	Approved	Intermediate	\N	Daily	Seeded assignment	2025-11-29 15:07:27.264874
842	24	Approved	\N	10	Monthly	Seeded request	\N
529	25	Approved	Advanced	\N	Weekly	Seeded assignment	2025-11-24 21:46:27.264874
185	24	Requested	Beginner	\N	Rarely	Seeded assignment	2025-12-03 00:43:27.264874
938	22	Requested	Beginner	8	\N	Seeded assignment	\N
706	19	Approved	Advanced	1	\N	Seeded assignment	\N
304	16	Requested	Beginner	\N	Weekly	Seeded assignment	\N
296	18	Requested	\N	\N	Rarely	Seeded request	2025-11-10 20:59:27.264874
970	16	Requested	Advanced	6	\N	Seeded assignment	2025-11-20 13:49:27.264874
31	20	Requested	Expert	\N	Daily	Seeded request	\N
528	23	Requested	Intermediate	5	\N	Seeded assignment	\N
622	21	Requested	\N	8	\N	Seeded request	\N
273	10	Approved	Beginner	\N	\N	Seeded request	2025-11-28 19:52:27.264874
887	13	Requested	Beginner	3	Rarely	Seeded assignment	\N
806	16	Approved	Expert	2	Rarely	Seeded assignment	\N
696	1	Approved	Intermediate	10	\N	Seeded request	2025-11-08 00:51:27.264874
324	12	Approved	Beginner	\N	\N	Seeded request	2025-11-08 03:16:27.264874
855	21	Approved	Expert	0	Daily	Seeded request	\N
891	4	Requested	\N	\N	Daily	Seeded assignment	2025-12-01 02:50:27.264874
430	25	Requested	\N	\N	Weekly	Seeded assignment	\N
627	1	Requested	Advanced	3	\N	Seeded assignment	\N
943	6	Requested	Beginner	10	Daily	Seeded request	\N
730	9	Approved	Beginner	0	Weekly	Seeded assignment	\N
634	8	Requested	Intermediate	\N	Rarely	Seeded assignment	2025-11-12 09:24:27.264874
284	20	Requested	\N	1	\N	Seeded assignment	2025-11-17 20:43:27.264874
619	7	Requested	\N	0	\N	Seeded assignment	2025-11-23 08:07:27.264874
655	18	Approved	\N	\N	Rarely	Seeded assignment	2025-11-22 05:22:27.264874
964	25	Requested	Expert	7	Rarely	Seeded request	2025-11-12 03:20:27.264874
651	22	Approved	\N	5	Rarely	Seeded assignment	\N
15	4	Approved	\N	\N	Daily	Seeded assignment	2025-11-14 10:33:27.264874
579	16	Approved	\N	5	Daily	Seeded request	\N
862	17	Approved	Beginner	\N	Weekly	Seeded request	2025-12-01 09:26:27.264874
898	11	Approved	Intermediate	7	\N	Seeded assignment	2025-11-09 20:52:27.264874
500	9	Requested	\N	2	\N	Seeded request	2025-11-04 13:05:27.264874
563	20	Approved	Advanced	\N	\N	Seeded assignment	\N
786	19	Approved	Advanced	\N	Daily	Seeded request	2025-11-28 03:23:27.264874
301	3	Approved	\N	6	\N	Seeded request	\N
226	9	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-04 07:20:27.264874
408	12	Requested	Advanced	6	\N	Seeded assignment	2025-11-06 09:23:27.264874
412	22	Requested	Intermediate	1	\N	Seeded request	2025-11-06 10:21:27.264874
721	25	Requested	Intermediate	\N	Weekly	Seeded assignment	2025-11-26 05:03:27.264874
195	21	Approved	\N	\N	Daily	Seeded request	2025-11-21 18:25:27.264874
35	8	Approved	\N	10	\N	Seeded assignment	\N
285	5	Approved	\N	\N	Daily	Seeded assignment	2025-11-14 00:57:27.264874
681	5	Approved	Advanced	4	Weekly	Seeded assignment	\N
617	18	Approved	\N	2	Daily	Seeded request	\N
125	4	Approved	Expert	0	Monthly	Seeded assignment	2025-12-01 23:54:27.264874
784	6	Approved	\N	\N	\N	Seeded request	\N
274	22	Approved	Expert	4	\N	Seeded request	\N
814	7	Approved	Expert	3	\N	Seeded assignment	2025-11-16 05:52:27.264874
918	12	Requested	Advanced	\N	Weekly	Seeded request	\N
106	5	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-15 03:48:27.264874
167	18	Approved	\N	\N	\N	Seeded assignment	\N
205	21	Requested	Advanced	0	\N	Seeded assignment	2025-11-21 11:08:27.264874
465	12	Requested	Beginner	9	Weekly	Seeded assignment	2025-11-10 06:34:27.264874
826	10	Approved	\N	0	\N	Seeded assignment	\N
44	7	Approved	Expert	\N	Weekly	Seeded assignment	2025-11-30 15:48:27.264874
30	24	Approved	Advanced	\N	Weekly	Seeded request	2025-11-21 06:46:27.264874
554	11	Approved	\N	3	Rarely	Seeded request	2025-11-19 02:12:27.264874
750	21	Requested	\N	\N	\N	Seeded assignment	\N
688	17	Approved	Intermediate	\N	\N	Seeded assignment	\N
880	16	Requested	Expert	\N	Weekly	Seeded assignment	2025-11-20 18:22:27.264874
335	5	Requested	Expert	\N	Weekly	Seeded request	\N
528	7	Approved	Intermediate	8	\N	Seeded assignment	2025-11-28 19:39:27.264874
599	19	Requested	Beginner	4	\N	Seeded assignment	\N
357	18	Requested	Intermediate	10	Daily	Seeded assignment	\N
785	13	Approved	Expert	1	Monthly	Seeded assignment	\N
433	22	Requested	Beginner	7	Daily	Seeded assignment	\N
479	12	Requested	Beginner	\N	\N	Seeded request	\N
210	6	Approved	Expert	\N	\N	Seeded request	\N
237	23	Approved	\N	\N	\N	Seeded request	2025-11-15 15:39:27.264874
230	13	Approved	Expert	5	\N	Seeded request	2025-11-13 22:13:27.264874
480	3	Approved	\N	\N	\N	Seeded assignment	\N
496	19	Approved	Expert	3	Weekly	Seeded assignment	\N
969	13	Approved	Beginner	\N	\N	Seeded assignment	2025-11-15 23:54:27.264874
207	25	Requested	\N	1	\N	Seeded assignment	\N
404	16	Requested	Advanced	\N	Daily	Seeded assignment	2025-11-19 02:12:27.264874
424	20	Approved	\N	1	\N	Seeded assignment	\N
532	1	Requested	Intermediate	\N	Daily	Seeded request	\N
142	18	Approved	Intermediate	3	Weekly	Seeded assignment	\N
773	8	Approved	Expert	2	Weekly	Seeded request	2025-11-07 13:44:27.264874
783	8	Approved	Beginner	6	Weekly	Seeded assignment	2025-11-18 04:44:27.264874
642	22	Requested	Advanced	3	Weekly	Seeded request	\N
789	22	Requested	\N	3	Weekly	Seeded assignment	2025-11-16 12:48:27.264874
965	9	Requested	Beginner	6	\N	Seeded request	2025-11-23 07:34:27.264874
558	17	Approved	\N	9	\N	Seeded request	\N
816	18	Approved	Intermediate	1	Monthly	Seeded request	\N
942	5	Requested	Advanced	\N	Weekly	Seeded request	\N
308	8	Requested	Intermediate	\N	\N	Seeded assignment	\N
859	6	Approved	\N	10	Rarely	Seeded request	2025-11-12 00:56:27.264874
152	22	Requested	Beginner	3	Weekly	Seeded request	2025-11-07 20:08:27.264874
442	12	Approved	\N	4	Daily	Seeded assignment	\N
575	4	Requested	Expert	9	Daily	Seeded assignment	2025-11-09 13:38:27.264874
76	10	Approved	Advanced	\N	Monthly	Seeded request	\N
251	19	Approved	Beginner	\N	Monthly	Seeded request	\N
531	24	Requested	Advanced	\N	Daily	Seeded request	\N
476	6	Requested	\N	\N	Rarely	Seeded request	2025-11-17 14:16:27.264874
837	22	Requested	Advanced	\N	\N	Seeded request	2025-11-21 23:40:27.264874
93	13	Requested	Advanced	1	Daily	Seeded assignment	\N
47	3	Approved	Advanced	1	Rarely	Seeded request	\N
27	5	Requested	\N	10	Daily	Seeded assignment	\N
632	21	Requested	Intermediate	\N	Weekly	Seeded assignment	2025-11-13 23:22:27.264874
351	10	Approved	Expert	8	Daily	Seeded assignment	\N
234	20	Approved	Advanced	0	Monthly	Seeded request	\N
208	7	Approved	\N	10	Daily	Seeded assignment	\N
165	4	Approved	\N	\N	Daily	Seeded request	2025-12-01 15:56:27.264874
748	4	Approved	Expert	\N	\N	Seeded request	\N
708	21	Requested	\N	5	Daily	Seeded request	\N
663	7	Requested	Advanced	\N	\N	Seeded request	\N
42	25	Approved	Expert	3	\N	Seeded assignment	\N
460	17	Approved	\N	\N	\N	Seeded request	\N
610	16	Approved	\N	\N	\N	Seeded assignment	\N
920	6	Approved	Advanced	7	\N	Seeded request	2025-11-20 07:58:27.264874
59	25	Requested	\N	9	Monthly	Seeded assignment	2025-11-27 15:07:27.264874
405	5	Requested	\N	4	Daily	Seeded assignment	2025-11-12 08:27:27.264874
82	13	Requested	Expert	9	Monthly	Seeded request	2025-11-24 20:32:27.264874
680	7	Approved	Beginner	\N	Daily	Seeded request	2025-11-26 11:34:27.264874
489	18	Approved	\N	4	Rarely	Seeded assignment	2025-11-26 17:21:27.264874
745	5	Approved	Expert	\N	Rarely	Seeded assignment	\N
779	11	Requested	Beginner	5	\N	Seeded assignment	\N
675	21	Requested	\N	2	Weekly	Seeded assignment	2025-11-14 08:28:27.264874
506	10	Approved	Beginner	\N	\N	Seeded assignment	2025-11-10 05:25:27.264874
741	9	Approved	\N	4	\N	Seeded request	\N
537	18	Requested	Expert	\N	Daily	Seeded assignment	2025-11-13 13:22:27.264874
117	21	Requested	Intermediate	\N	\N	Seeded request	2025-11-25 21:58:27.264874
287	16	Requested	Beginner	\N	Daily	Seeded assignment	2025-11-08 09:02:27.264874
974	18	Approved	Advanced	\N	Daily	Seeded assignment	\N
426	9	Approved	Expert	\N	Daily	Seeded assignment	\N
724	10	Approved	Expert	7	\N	Seeded request	\N
320	9	Requested	\N	9	\N	Seeded assignment	\N
303	4	Approved	Advanced	5	\N	Seeded request	2025-11-11 11:49:27.264874
542	24	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-21 22:12:27.264874
288	11	Approved	\N	\N	\N	Seeded assignment	\N
738	11	Approved	\N	\N	Weekly	Seeded assignment	\N
13	1	Approved	Intermediate	7	\N	Seeded request	2025-11-26 00:12:27.264874
231	24	Approved	Beginner	7	Weekly	Seeded request	2025-11-06 15:12:27.264874
564	7	Requested	Beginner	0	Rarely	Seeded assignment	\N
232	19	Approved	\N	\N	\N	Seeded request	\N
484	11	Requested	Advanced	8	Weekly	Seeded assignment	\N
840	7	Approved	Beginner	6	\N	Seeded request	2025-11-30 22:33:27.264874
742	23	Approved	Expert	\N	\N	Seeded assignment	2025-12-01 05:22:27.264874
223	24	Approved	Beginner	\N	\N	Seeded assignment	2025-11-24 21:18:27.264874
447	6	Requested	Advanced	4	\N	Seeded assignment	2025-11-07 16:53:27.264874
770	12	Requested	Beginner	\N	\N	Seeded request	2025-11-25 12:18:27.264874
788	23	Approved	Advanced	\N	Rarely	Seeded request	\N
41	7	Approved	Intermediate	4	Rarely	Seeded assignment	\N
483	8	Approved	\N	6	\N	Seeded request	\N
89	1	Requested	Intermediate	1	\N	Seeded request	\N
881	8	Approved	\N	4	Daily	Seeded assignment	\N
827	1	Approved	Intermediate	\N	\N	Seeded request	2025-11-12 09:55:27.264874
303	18	Approved	\N	9	\N	Seeded request	\N
954	13	Requested	Intermediate	\N	\N	Seeded assignment	\N
49	17	Requested	Advanced	\N	Monthly	Seeded request	\N
471	22	Approved	Advanced	\N	Rarely	Seeded request	\N
968	23	Approved	\N	\N	Weekly	Seeded request	\N
509	7	Approved	Advanced	\N	Monthly	Seeded request	\N
569	11	Approved	\N	3	Weekly	Seeded assignment	2025-11-04 22:13:27.264874
714	16	Approved	\N	4	Monthly	Seeded assignment	\N
167	3	Approved	\N	\N	Monthly	Seeded request	2025-11-21 21:35:27.264874
701	19	Approved	Beginner	\N	Rarely	Seeded assignment	2025-11-17 15:22:27.264874
617	3	Approved	\N	\N	Daily	Seeded assignment	2025-11-04 23:39:27.264874
21	18	Requested	\N	1	Daily	Seeded request	\N
366	13	Requested	\N	\N	Monthly	Seeded assignment	\N
58	17	Approved	Expert	\N	Rarely	Seeded request	\N
31	22	Approved	Beginner	10	Rarely	Seeded assignment	\N
717	6	Approved	Advanced	\N	\N	Seeded request	\N
536	12	Approved	Advanced	\N	Weekly	Seeded request	\N
57	22	Approved	Advanced	\N	Weekly	Seeded assignment	\N
13	11	Approved	\N	1	Weekly	Seeded assignment	2025-11-24 15:19:27.264874
252	4	Approved	Expert	6	Daily	Seeded assignment	\N
281	18	Requested	Intermediate	7	Monthly	Seeded assignment	\N
589	13	Approved	Beginner	\N	Rarely	Seeded request	\N
935	5	Requested	Intermediate	5	Weekly	Seeded request	\N
358	19	Approved	\N	\N	Weekly	Seeded request	\N
401	18	Approved	Expert	10	Weekly	Seeded assignment	2025-11-13 08:44:27.264874
655	3	Approved	Expert	0	Daily	Seeded assignment	\N
898	9	Requested	\N	\N	\N	Seeded assignment	\N
396	5	Approved	Advanced	\N	\N	Seeded assignment	\N
936	25	Requested	\N	2	Rarely	Seeded request	\N
298	13	Approved	Intermediate	2	Weekly	Seeded assignment	\N
467	25	Approved	Advanced	\N	Rarely	Seeded request	\N
527	24	Approved	\N	5	\N	Seeded request	2025-11-26 08:18:27.264874
797	21	Approved	Beginner	3	\N	Seeded assignment	\N
648	25	Approved	Advanced	6	\N	Seeded assignment	2025-11-30 01:42:27.264874
18	9	Requested	Intermediate	2	Daily	Seeded assignment	\N
629	3	Requested	Intermediate	\N	Weekly	Seeded assignment	\N
198	3	Requested	\N	3	Monthly	Seeded assignment	\N
684	9	Requested	Advanced	4	\N	Seeded assignment	\N
30	8	Approved	\N	7	\N	Seeded assignment	2025-11-13 15:48:27.264874
905	17	Requested	\N	1	\N	Seeded request	\N
540	11	Approved	\N	4	\N	Seeded assignment	2025-11-10 07:26:27.264874
16	25	Approved	\N	8	\N	Seeded assignment	\N
712	18	Approved	\N	2	\N	Seeded request	2025-11-28 13:00:27.264874
291	21	Approved	Beginner	4	Weekly	Seeded assignment	2025-11-19 01:38:27.264874
805	22	Approved	Intermediate	3	\N	Seeded request	\N
260	24	Approved	Intermediate	8	Weekly	Seeded assignment	2025-12-01 16:20:27.264874
626	3	Approved	\N	6	\N	Seeded assignment	\N
17	4	Approved	\N	\N	Monthly	Seeded request	\N
762	8	Approved	Expert	6	Monthly	Seeded assignment	\N
63	24	Requested	Intermediate	\N	Monthly	Seeded request	\N
122	8	Approved	Advanced	1	\N	Seeded assignment	\N
979	5	Approved	Advanced	0	Weekly	Seeded request	2025-11-30 23:36:27.264874
624	3	Approved	Intermediate	\N	Monthly	Seeded request	\N
199	17	Requested	Beginner	9	Rarely	Seeded assignment	2025-11-27 13:49:27.264874
715	7	Requested	Advanced	9	Daily	Seeded assignment	2025-11-17 13:29:27.264874
241	4	Approved	Expert	6	Weekly	Seeded assignment	2025-11-07 12:56:27.264874
83	20	Approved	Advanced	1	Weekly	Seeded request	2025-11-19 20:12:27.264874
723	18	Approved	Advanced	2	Daily	Seeded assignment	\N
879	18	Requested	Advanced	\N	\N	Seeded request	2025-11-05 23:37:27.264874
461	11	Approved	Intermediate	1	Daily	Seeded request	2025-11-10 17:31:27.264874
86	10	Requested	\N	10	Rarely	Seeded assignment	2025-11-14 10:19:27.264874
508	22	Approved	Beginner	0	\N	Seeded request	\N
148	25	Requested	\N	\N	Monthly	Seeded assignment	\N
851	20	Requested	Advanced	4	\N	Seeded request	2025-12-02 17:39:27.264874
308	24	Requested	Beginner	10	\N	Seeded request	\N
494	19	Requested	\N	2	Weekly	Seeded assignment	\N
834	22	Approved	Expert	\N	\N	Seeded assignment	\N
882	22	Approved	Expert	\N	Weekly	Seeded request	2025-11-14 14:07:27.264874
142	4	Requested	\N	\N	\N	Seeded assignment	2025-11-06 06:15:27.264874
671	17	Approved	Expert	2	Daily	Seeded assignment	\N
857	10	Requested	Beginner	7	Monthly	Seeded assignment	2025-11-17 04:56:27.264874
70	25	Requested	Expert	\N	\N	Seeded assignment	\N
760	25	Requested	\N	\N	Monthly	Seeded request	2025-11-29 23:56:27.264874
939	6	Requested	\N	2	Daily	Seeded request	\N
743	25	Requested	\N	10	Monthly	Seeded assignment	\N
160	9	Approved	Beginner	4	Weekly	Seeded request	\N
211	18	Requested	Expert	\N	Weekly	Seeded request	\N
640	9	Approved	\N	6	Daily	Seeded assignment	\N
646	5	Requested	Intermediate	5	Weekly	Seeded request	2025-11-03 10:52:27.264874
36	10	Requested	Advanced	0	\N	Seeded assignment	2025-11-28 10:55:27.264874
252	3	Requested	Intermediate	\N	Daily	Seeded request	\N
728	13	Requested	Intermediate	5	Weekly	Seeded assignment	\N
752	16	Requested	Beginner	\N	Rarely	Seeded request	\N
451	10	Requested	Intermediate	10	\N	Seeded assignment	\N
611	25	Requested	\N	\N	Weekly	Seeded request	\N
64	22	Approved	Expert	2	Monthly	Seeded request	2025-11-08 05:45:27.264874
323	17	Requested	Intermediate	3	Daily	Seeded request	\N
167	4	Requested	\N	\N	Daily	Seeded assignment	\N
243	16	Requested	Beginner	10	\N	Seeded assignment	2025-11-08 10:57:27.264874
507	20	Approved	Expert	\N	\N	Seeded assignment	2025-11-11 05:31:27.264874
843	22	Requested	Beginner	\N	Weekly	Seeded request	2025-12-01 20:09:27.264874
53	10	Approved	Beginner	8	Daily	Seeded assignment	2025-11-07 10:05:27.264874
72	1	Requested	Beginner	7	Daily	Seeded assignment	\N
609	19	Requested	Beginner	\N	Weekly	Seeded assignment	\N
738	9	Approved	Intermediate	10	\N	Seeded assignment	\N
347	17	Approved	\N	\N	\N	Seeded assignment	2025-11-14 17:53:27.264874
299	6	Approved	\N	1	Weekly	Seeded request	\N
38	5	Requested	\N	2	Daily	Seeded assignment	\N
128	5	Requested	Intermediate	\N	\N	Seeded assignment	\N
234	22	Approved	Expert	10	\N	Seeded request	\N
741	11	Approved	\N	\N	Monthly	Seeded request	\N
256	13	Requested	Advanced	\N	Rarely	Seeded request	\N
832	21	Approved	Beginner	\N	\N	Seeded assignment	\N
984	12	Approved	Beginner	\N	Weekly	Seeded request	2025-11-28 18:34:27.264874
537	3	Approved	\N	2	\N	Seeded assignment	2025-11-11 01:35:27.264874
23	10	Approved	\N	9	Monthly	Seeded assignment	2025-11-09 10:35:27.264874
967	6	Approved	Beginner	\N	Daily	Seeded request	\N
591	23	Approved	\N	1	\N	Seeded request	\N
55	5	Approved	\N	6	Weekly	Seeded assignment	2025-11-04 07:35:27.264874
764	7	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-14 04:28:27.264874
849	7	Requested	Advanced	9	Daily	Seeded assignment	\N
315	22	Requested	\N	\N	Monthly	Seeded request	2025-11-18 21:28:27.264874
278	13	Requested	\N	5	Rarely	Seeded assignment	\N
580	23	Approved	Advanced	\N	Weekly	Seeded assignment	\N
5	20	Approved	Intermediate	\N	Weekly	Seeded request	\N
588	4	Requested	\N	\N	Rarely	Seeded assignment	\N
874	21	Approved	\N	7	Rarely	Seeded assignment	2025-11-16 01:33:27.264874
924	24	Requested	\N	8	\N	Seeded assignment	\N
956	16	Requested	\N	\N	\N	Seeded request	\N
505	1	Approved	Beginner	5	\N	Seeded request	\N
280	18	Approved	\N	2	Daily	Seeded request	2025-12-01 03:41:27.264874
798	21	Requested	\N	0	Weekly	Seeded request	\N
65	19	Approved	Advanced	\N	Weekly	Seeded assignment	2025-11-11 12:47:27.264874
228	9	Approved	Advanced	4	\N	Seeded assignment	\N
331	21	Approved	\N	10	\N	Seeded request	\N
152	20	Approved	Expert	\N	\N	Seeded assignment	\N
742	7	Approved	Expert	9	\N	Seeded request	\N
71	4	Approved	Intermediate	7	\N	Seeded assignment	2025-11-05 10:03:27.264874
475	20	Approved	Advanced	\N	Daily	Seeded request	\N
837	20	Requested	\N	9	Daily	Seeded request	2025-11-09 20:01:27.264874
446	8	Requested	Beginner	\N	Rarely	Seeded request	2025-11-29 05:33:27.264874
488	23	Approved	\N	\N	Weekly	Seeded request	\N
241	3	Requested	Expert	\N	\N	Seeded assignment	\N
877	6	Approved	\N	\N	Daily	Seeded request	\N
546	13	Requested	Intermediate	3	\N	Seeded assignment	2025-11-11 16:17:27.264874
6	23	Requested	Expert	\N	Daily	Seeded request	2025-11-11 07:26:27.264874
490	21	Requested	Beginner	9	Weekly	Seeded assignment	\N
848	1	Approved	\N	\N	\N	Seeded assignment	\N
554	9	Approved	Intermediate	10	Daily	Seeded assignment	\N
221	19	Approved	\N	\N	Daily	Seeded request	\N
842	8	Approved	Advanced	\N	Daily	Seeded assignment	2025-12-02 09:40:27.264874
381	1	Approved	Expert	2	\N	Seeded request	\N
24	13	Requested	\N	5	Daily	Seeded request	\N
368	17	Approved	\N	9	\N	Seeded assignment	2025-11-11 16:41:27.264874
54	10	Requested	Intermediate	4	Rarely	Seeded assignment	2025-11-24 17:40:27.264874
47	18	Requested	Expert	8	\N	Seeded assignment	\N
74	23	Approved	Intermediate	7	Daily	Seeded assignment	\N
914	3	Approved	Advanced	4	\N	Seeded assignment	2025-11-27 06:54:27.264874
274	12	Approved	Advanced	9	Monthly	Seeded assignment	2025-11-18 05:00:27.264874
103	10	Requested	\N	\N	Weekly	Seeded assignment	\N
364	25	Requested	Advanced	1	Monthly	Seeded request	2025-12-02 10:20:27.264874
478	4	Approved	Beginner	\N	Daily	Seeded request	\N
608	25	Requested	Advanced	\N	Monthly	Seeded request	2025-11-09 09:56:27.264874
653	19	Approved	Expert	9	\N	Seeded request	2025-11-06 11:58:27.264874
597	24	Requested	Expert	\N	Weekly	Seeded assignment	2025-11-11 12:59:27.264874
543	20	Requested	\N	1	Weekly	Seeded assignment	2025-11-24 03:49:27.264874
250	1	Approved	Expert	4	Monthly	Seeded assignment	\N
407	17	Approved	\N	\N	\N	Seeded assignment	2025-11-18 16:13:27.264874
770	20	Approved	Expert	\N	\N	Seeded request	2025-11-15 15:21:27.264874
868	11	Requested	\N	1	Monthly	Seeded request	\N
768	25	Approved	Advanced	\N	\N	Seeded assignment	2025-11-05 10:21:27.264874
965	11	Requested	Intermediate	5	Monthly	Seeded assignment	2025-11-18 13:20:27.264874
84	23	Requested	\N	\N	Weekly	Seeded assignment	2025-12-01 00:25:27.264874
744	6	Approved	Expert	5	Monthly	Seeded request	\N
433	20	Requested	Expert	\N	\N	Seeded assignment	2025-11-28 11:15:27.264874
629	4	Requested	\N	10	Weekly	Seeded request	2025-11-04 20:01:27.264874
985	6	Approved	\N	4	Weekly	Seeded assignment	2025-11-23 09:53:27.264874
200	17	Approved	\N	\N	\N	Seeded assignment	\N
642	20	Approved	Beginner	\N	Rarely	Seeded assignment	\N
860	25	Approved	\N	\N	\N	Seeded assignment	\N
753	21	Requested	Beginner	5	Weekly	Seeded assignment	2025-11-27 11:19:27.264874
348	11	Requested	Advanced	2	\N	Seeded request	2025-11-06 10:04:27.264874
731	24	Approved	Expert	2	Weekly	Seeded request	2025-12-02 13:14:27.264874
875	13	Approved	Expert	\N	\N	Seeded assignment	\N
652	18	Requested	Intermediate	8	Daily	Seeded assignment	\N
806	13	Approved	Intermediate	\N	Weekly	Seeded request	2025-11-04 11:55:27.264874
68	18	Requested	\N	\N	Weekly	Seeded assignment	\N
476	25	Approved	Advanced	\N	Weekly	Seeded assignment	\N
494	18	Approved	Expert	\N	Daily	Seeded assignment	\N
141	6	Approved	\N	\N	Daily	Seeded assignment	\N
765	9	Approved	\N	7	\N	Seeded assignment	\N
879	19	Approved	Advanced	\N	\N	Seeded assignment	2025-11-22 21:27:27.264874
374	12	Requested	Beginner	\N	Monthly	Seeded assignment	\N
25	3	Requested	Beginner	0	Daily	Seeded request	2025-11-04 22:00:27.264874
304	13	Approved	Intermediate	\N	\N	Seeded assignment	\N
78	11	Requested	\N	2	Rarely	Seeded assignment	\N
952	19	Approved	\N	2	\N	Seeded request	\N
923	19	Approved	\N	5	\N	Seeded request	\N
254	20	Approved	\N	0	Monthly	Seeded request	2025-11-21 02:52:27.264874
9	17	Requested	\N	\N	\N	Seeded assignment	2025-11-04 06:11:27.264874
565	18	Requested	Beginner	6	\N	Seeded assignment	2025-11-28 01:18:27.264874
948	21	Requested	\N	\N	\N	Seeded assignment	\N
432	20	Approved	\N	\N	Weekly	Seeded request	\N
859	25	Approved	\N	9	Weekly	Seeded request	\N
330	22	Approved	\N	10	Rarely	Seeded request	2025-12-02 08:50:27.264874
353	12	Requested	\N	5	\N	Seeded assignment	\N
605	7	Approved	\N	6	Rarely	Seeded assignment	2025-11-05 06:50:27.264874
979	20	Approved	Expert	\N	Weekly	Seeded request	\N
210	25	Requested	\N	5	\N	Seeded assignment	\N
318	23	Approved	\N	\N	\N	Seeded assignment	2025-11-09 00:22:27.264874
631	5	Approved	Advanced	\N	Rarely	Seeded assignment	\N
100	11	Approved	Advanced	10	Monthly	Seeded request	\N
189	19	Approved	Beginner	\N	Weekly	Seeded assignment	\N
638	11	Approved	\N	\N	\N	Seeded request	\N
474	5	Requested	Beginner	\N	\N	Seeded assignment	\N
584	25	Approved	\N	2	Daily	Seeded assignment	\N
397	22	Requested	Expert	\N	Weekly	Seeded request	2025-12-02 00:46:27.264874
266	18	Requested	\N	9	\N	Seeded assignment	\N
368	21	Approved	Beginner	\N	\N	Seeded assignment	\N
646	12	Approved	Beginner	\N	Weekly	Seeded request	\N
7	10	Requested	\N	2	Rarely	Seeded assignment	2025-11-23 15:23:27.264874
850	16	Requested	\N	\N	\N	Seeded request	\N
579	13	Approved	\N	3	Monthly	Seeded assignment	\N
158	11	Approved	\N	10	Monthly	Seeded request	2025-11-11 17:48:27.264874
383	17	Approved	\N	3	Weekly	Seeded assignment	2025-11-22 15:25:27.264874
464	8	Approved	\N	4	Monthly	Seeded assignment	\N
421	12	Requested	\N	2	\N	Seeded assignment	2025-11-27 14:45:27.264874
120	1	Approved	Expert	\N	Monthly	Seeded request	2025-11-28 23:05:27.264874
452	22	Approved	Beginner	6	\N	Seeded request	2025-11-04 20:34:27.264874
449	3	Approved	Advanced	3	\N	Seeded request	2025-11-06 05:05:27.264874
37	20	Approved	Advanced	9	\N	Seeded assignment	2025-11-30 07:36:27.264874
793	24	Requested	\N	9	Monthly	Seeded request	2025-11-16 19:17:27.264874
982	25	Requested	\N	1	Monthly	Seeded assignment	2025-11-25 11:39:27.264874
747	25	Requested	Intermediate	\N	\N	Seeded request	2025-11-08 15:24:27.264874
756	16	Requested	Intermediate	3	\N	Seeded assignment	\N
647	22	Approved	Advanced	9	\N	Seeded assignment	\N
188	10	Approved	\N	\N	\N	Seeded assignment	2025-11-27 16:04:27.264874
375	10	Requested	\N	\N	Monthly	Seeded request	2025-11-06 12:06:27.264874
301	19	Approved	Beginner	1	\N	Seeded request	\N
497	22	Requested	Expert	4	\N	Seeded assignment	2025-11-07 06:43:27.264874
270	16	Approved	\N	1	Monthly	Seeded assignment	2025-11-18 12:21:27.264874
886	13	Requested	Beginner	3	Monthly	Seeded request	2025-11-19 22:03:27.264874
847	4	Requested	Expert	5	Rarely	Seeded request	\N
941	18	Requested	Intermediate	2	\N	Seeded request	2025-11-24 17:42:27.264874
940	7	Approved	Beginner	5	Monthly	Seeded request	\N
791	24	Approved	\N	\N	\N	Seeded assignment	2025-11-06 16:20:27.264874
453	17	Requested	Expert	\N	\N	Seeded request	\N
514	23	Approved	Expert	\N	Monthly	Seeded request	\N
705	13	Approved	\N	\N	\N	Seeded assignment	2025-11-18 02:14:27.264874
804	18	Approved	Beginner	1	\N	Seeded assignment	\N
920	25	Approved	Expert	\N	\N	Seeded assignment	\N
845	8	Approved	\N	\N	Rarely	Seeded assignment	\N
541	3	Requested	Beginner	1	Weekly	Seeded assignment	\N
603	18	Approved	Beginner	\N	Daily	Seeded assignment	\N
577	22	Approved	\N	6	Daily	Seeded assignment	2025-11-11 11:58:27.264874
76	8	Approved	\N	7	Monthly	Seeded request	2025-11-12 05:04:27.264874
113	18	Approved	\N	5	Weekly	Seeded request	\N
402	21	Requested	Advanced	0	\N	Seeded request	2025-11-08 04:38:27.264874
937	20	Approved	\N	4	Daily	Seeded assignment	\N
101	16	Approved	Beginner	1	Daily	Seeded assignment	\N
473	13	Requested	Beginner	\N	Daily	Seeded assignment	\N
307	3	Approved	Beginner	\N	\N	Seeded request	\N
692	18	Approved	Expert	\N	\N	Seeded assignment	\N
63	10	Approved	Beginner	10	Rarely	Seeded request	\N
803	18	Approved	\N	8	\N	Seeded request	2025-11-04 00:51:27.264874
380	21	Approved	Intermediate	2	Monthly	Seeded request	2025-11-22 00:29:27.264874
400	13	Approved	Advanced	5	\N	Seeded request	\N
689	13	Approved	Advanced	6	Monthly	Seeded assignment	\N
610	13	Requested	Intermediate	\N	Weekly	Seeded assignment	2025-12-03 05:33:27.264874
344	10	Approved	Beginner	3	Rarely	Seeded request	\N
789	5	Requested	Intermediate	9	Daily	Seeded assignment	2025-11-21 08:51:27.264874
469	21	Requested	\N	10	\N	Seeded assignment	\N
719	5	Requested	\N	\N	Rarely	Seeded request	\N
937	12	Approved	Beginner	6	Daily	Seeded assignment	\N
152	5	Requested	\N	4	Monthly	Seeded request	\N
883	22	Approved	Expert	\N	Rarely	Seeded assignment	\N
423	17	Requested	Advanced	\N	Daily	Seeded request	\N
553	23	Approved	Advanced	\N	\N	Seeded request	\N
873	10	Approved	\N	\N	\N	Seeded assignment	2025-11-14 09:05:27.264874
797	17	Approved	\N	5	Daily	Seeded assignment	\N
901	17	Requested	\N	\N	\N	Seeded request	2025-11-19 04:28:27.264874
36	24	Approved	\N	10	Monthly	Seeded assignment	\N
649	10	Requested	Expert	\N	\N	Seeded request	\N
755	20	Requested	Expert	2	Weekly	Seeded request	\N
61	17	Requested	Beginner	\N	Daily	Seeded request	2025-11-15 00:54:27.264874
595	19	Requested	Advanced	\N	\N	Seeded assignment	\N
47	19	Requested	\N	6	\N	Seeded request	\N
192	8	Approved	\N	\N	\N	Seeded request	\N
62	7	Requested	\N	8	\N	Seeded assignment	\N
217	25	Approved	\N	8	Daily	Seeded assignment	2025-11-07 03:16:27.264874
196	4	Approved	Advanced	\N	Rarely	Seeded request	2025-11-05 08:28:27.264874
422	21	Requested	\N	1	Daily	Seeded assignment	\N
51	6	Requested	\N	\N	Daily	Seeded assignment	2025-11-26 23:09:27.264874
869	5	Approved	Beginner	\N	\N	Seeded assignment	\N
931	11	Requested	Expert	10	Rarely	Seeded assignment	2025-11-22 14:29:27.264874
181	13	Approved	Beginner	0	Rarely	Seeded request	\N
338	8	Requested	Advanced	10	Monthly	Seeded request	\N
276	3	Requested	Intermediate	\N	Monthly	Seeded assignment	\N
215	12	Approved	Beginner	4	\N	Seeded request	2025-11-23 01:16:27.264874
836	9	Approved	Intermediate	5	Weekly	Seeded request	2025-11-26 11:58:27.264874
60	21	Requested	Intermediate	\N	\N	Seeded assignment	\N
599	3	Approved	Advanced	\N	Daily	Seeded assignment	\N
293	5	Requested	\N	\N	\N	Seeded assignment	\N
335	22	Approved	Advanced	7	Rarely	Seeded assignment	2025-12-02 04:59:27.264874
419	19	Approved	Expert	0	\N	Seeded request	2025-11-08 00:58:27.264874
573	17	Requested	Advanced	0	\N	Seeded assignment	\N
317	12	Requested	\N	2	Daily	Seeded request	\N
825	1	Approved	\N	\N	Weekly	Seeded request	2025-11-29 11:08:27.264874
352	6	Approved	\N	2	\N	Seeded assignment	2025-11-28 02:41:27.264874
37	12	Requested	\N	2	Daily	Seeded assignment	\N
99	7	Approved	\N	1	\N	Seeded request	\N
53	24	Approved	\N	\N	Weekly	Seeded assignment	\N
235	8	Requested	Advanced	10	Monthly	Seeded assignment	\N
639	23	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-11 12:53:27.264874
404	13	Approved	Advanced	8	Daily	Seeded request	\N
43	10	Approved	Intermediate	5	Monthly	Seeded assignment	\N
187	23	Approved	\N	4	Daily	Seeded request	2025-12-01 18:29:27.264874
878	25	Approved	Intermediate	0	\N	Seeded assignment	\N
969	16	Approved	\N	\N	Daily	Seeded request	2025-11-25 02:25:27.264874
307	4	Requested	Intermediate	8	Weekly	Seeded request	\N
867	25	Requested	\N	8	\N	Seeded assignment	2025-11-17 18:49:27.264874
858	24	Approved	Beginner	\N	\N	Seeded assignment	2025-11-09 15:03:27.264874
482	10	Approved	Intermediate	10	Weekly	Seeded request	2025-11-08 15:07:27.264874
912	21	Requested	Expert	5	Monthly	Seeded assignment	2025-11-03 08:25:27.264874
157	17	Approved	Advanced	0	Daily	Seeded assignment	2025-12-01 18:37:27.264874
820	11	Approved	\N	0	\N	Seeded request	\N
915	13	Approved	\N	2	Weekly	Seeded assignment	\N
107	11	Requested	\N	3	Weekly	Seeded assignment	\N
964	6	Requested	Intermediate	5	Rarely	Seeded assignment	2025-11-07 17:14:27.264874
56	19	Requested	Intermediate	4	Weekly	Seeded assignment	\N
609	18	Approved	\N	\N	Weekly	Seeded request	\N
171	24	Approved	\N	10	Daily	Seeded request	\N
957	1	Approved	\N	10	Daily	Seeded assignment	\N
822	18	Requested	Intermediate	\N	Weekly	Seeded assignment	2025-11-12 09:04:27.264874
924	10	Approved	\N	3	\N	Seeded request	2025-11-19 05:02:27.264874
880	13	Approved	Advanced	6	\N	Seeded assignment	\N
979	12	Requested	\N	7	Rarely	Seeded assignment	2025-11-21 01:02:27.264874
432	12	Approved	\N	2	\N	Seeded assignment	2025-11-14 11:09:27.264874
312	7	Requested	Expert	3	\N	Seeded assignment	\N
683	7	Approved	Intermediate	\N	Daily	Seeded assignment	\N
966	11	Requested	Expert	\N	Daily	Seeded assignment	\N
77	19	Requested	\N	\N	Rarely	Seeded assignment	2025-11-16 22:39:27.264874
318	7	Approved	\N	8	Rarely	Seeded assignment	\N
140	19	Requested	Beginner	10	\N	Seeded request	\N
710	23	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-23 23:45:27.264874
254	12	Approved	Beginner	7	Monthly	Seeded assignment	\N
656	12	Approved	Beginner	7	\N	Seeded assignment	\N
429	18	Approved	Beginner	6	Daily	Seeded assignment	\N
305	7	Requested	\N	0	\N	Seeded assignment	\N
29	8	Requested	Advanced	3	\N	Seeded assignment	2025-11-24 02:44:27.264874
374	20	Approved	\N	\N	\N	Seeded assignment	\N
830	8	Approved	\N	8	Rarely	Seeded assignment	\N
292	22	Requested	Advanced	4	Daily	Seeded assignment	2025-11-22 14:04:27.264874
811	23	Approved	Beginner	2	Daily	Seeded assignment	\N
578	13	Approved	Intermediate	6	\N	Seeded assignment	\N
666	21	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-09 19:06:27.264874
15	19	Approved	\N	\N	Weekly	Seeded request	\N
547	13	Requested	\N	\N	\N	Seeded assignment	\N
449	4	Approved	\N	\N	Rarely	Seeded assignment	\N
27	10	Approved	Beginner	6	Rarely	Seeded assignment	\N
3	4	Requested	Intermediate	\N	\N	Seeded assignment	\N
884	1	Requested	Intermediate	7	\N	Seeded assignment	\N
401	6	Approved	Beginner	0	Daily	Seeded assignment	2025-11-27 07:52:27.264874
283	9	Requested	\N	0	\N	Seeded assignment	\N
110	20	Requested	Beginner	\N	Monthly	Seeded assignment	\N
831	12	Approved	\N	7	Weekly	Seeded assignment	\N
920	4	Approved	Intermediate	\N	\N	Seeded request	\N
165	6	Requested	Expert	4	Weekly	Seeded request	2025-11-12 14:00:27.264874
761	13	Approved	Intermediate	\N	\N	Seeded request	2025-11-30 15:48:27.264874
218	17	Approved	Advanced	5	\N	Seeded assignment	\N
900	21	Requested	\N	9	Weekly	Seeded assignment	\N
395	13	Requested	Expert	10	Rarely	Seeded request	2025-11-06 21:36:27.264874
988	11	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-27 03:58:27.264874
824	22	Approved	\N	\N	\N	Seeded assignment	\N
259	16	Approved	\N	0	Rarely	Seeded request	\N
459	8	Requested	Expert	\N	\N	Seeded request	\N
845	5	Approved	Expert	4	Weekly	Seeded assignment	\N
161	1	Approved	Beginner	8	Rarely	Seeded request	\N
437	25	Approved	Intermediate	0	Daily	Seeded request	\N
144	9	Requested	Advanced	\N	\N	Seeded request	2025-11-19 10:34:27.264874
444	8	Requested	\N	6	Monthly	Seeded assignment	2025-11-13 01:15:27.264874
423	16	Requested	Advanced	5	\N	Seeded assignment	2025-11-15 12:56:27.264874
291	16	Requested	Expert	3	Weekly	Seeded request	2025-12-02 23:56:27.264874
604	12	Requested	\N	7	Daily	Seeded assignment	\N
82	17	Approved	Expert	\N	\N	Seeded assignment	2025-11-18 11:05:27.264874
274	8	Approved	Intermediate	6	Weekly	Seeded request	\N
602	22	Approved	\N	7	\N	Seeded assignment	2025-11-06 10:03:27.264874
177	24	Approved	Intermediate	7	\N	Seeded request	2025-11-07 13:40:27.264874
460	13	Approved	Expert	9	\N	Seeded assignment	2025-11-11 01:46:27.264874
412	8	Approved	\N	\N	Weekly	Seeded assignment	\N
504	21	Approved	\N	\N	Rarely	Seeded assignment	2025-11-11 20:50:27.264874
881	20	Requested	Intermediate	\N	Daily	Seeded assignment	\N
483	20	Requested	Advanced	1	Daily	Seeded assignment	\N
464	5	Approved	Advanced	6	\N	Seeded request	\N
870	19	Requested	Beginner	3	Monthly	Seeded request	\N
838	10	Requested	Beginner	\N	Rarely	Seeded assignment	\N
61	16	Requested	\N	0	\N	Seeded assignment	\N
403	7	Requested	\N	3	Monthly	Seeded request	2025-11-04 09:12:27.264874
150	3	Approved	Intermediate	10	\N	Seeded assignment	\N
584	4	Requested	\N	\N	Daily	Seeded assignment	\N
376	6	Approved	Intermediate	9	Weekly	Seeded assignment	2025-11-14 16:29:27.264874
251	25	Approved	\N	3	Rarely	Seeded assignment	\N
240	3	Requested	Expert	\N	Daily	Seeded assignment	\N
158	7	Requested	Advanced	3	\N	Seeded assignment	\N
879	6	Requested	Intermediate	\N	\N	Seeded assignment	\N
269	13	Requested	Beginner	2	\N	Seeded assignment	\N
515	6	Approved	Expert	\N	Daily	Seeded assignment	\N
141	19	Requested	\N	\N	\N	Seeded assignment	\N
264	25	Requested	Expert	3	Weekly	Seeded request	2025-11-28 08:47:27.264874
398	23	Approved	\N	\N	Daily	Seeded assignment	\N
137	10	Approved	Intermediate	8	\N	Seeded assignment	2025-11-27 21:54:27.264874
336	5	Approved	\N	\N	Weekly	Seeded request	\N
592	9	Requested	\N	9	Daily	Seeded request	\N
977	6	Requested	\N	2	Daily	Seeded request	\N
631	8	Requested	Beginner	7	\N	Seeded request	2025-11-30 10:38:27.264874
122	20	Approved	\N	9	Rarely	Seeded request	\N
506	5	Approved	\N	\N	Daily	Seeded request	\N
526	21	Requested	\N	\N	Daily	Seeded assignment	\N
558	13	Requested	\N	\N	\N	Seeded assignment	\N
67	13	Requested	Beginner	\N	\N	Seeded request	\N
585	20	Approved	\N	\N	Daily	Seeded request	2025-11-06 00:16:27.264874
918	24	Requested	Intermediate	\N	\N	Seeded assignment	\N
157	16	Approved	\N	0	\N	Seeded assignment	\N
714	21	Requested	\N	\N	Monthly	Seeded request	2025-11-15 16:22:27.264874
386	5	Requested	Intermediate	4	Daily	Seeded assignment	2025-11-13 12:51:27.264874
431	1	Requested	\N	8	\N	Seeded assignment	2025-11-15 04:14:27.264874
230	17	Requested	\N	5	Daily	Seeded assignment	\N
493	23	Approved	Advanced	1	\N	Seeded request	2025-11-12 09:27:27.264874
612	3	Approved	Beginner	1	\N	Seeded assignment	\N
468	6	Requested	Advanced	6	\N	Seeded assignment	\N
503	16	Approved	Beginner	5	\N	Seeded request	\N
639	11	Requested	Beginner	\N	\N	Seeded request	2025-11-03 10:23:27.264874
538	3	Requested	Beginner	4	Monthly	Seeded assignment	2025-11-20 09:44:27.264874
774	21	Requested	Advanced	\N	Monthly	Seeded assignment	\N
835	13	Requested	Intermediate	6	Daily	Seeded assignment	\N
731	22	Approved	Intermediate	10	Daily	Seeded assignment	\N
512	24	Approved	Beginner	\N	Weekly	Seeded assignment	\N
721	19	Requested	Beginner	5	\N	Seeded request	2025-11-08 08:53:27.264874
926	4	Requested	Intermediate	\N	Monthly	Seeded request	2025-11-30 22:37:27.264874
455	17	Requested	\N	\N	Monthly	Seeded assignment	\N
147	9	Approved	\N	3	Daily	Seeded request	2025-11-29 08:40:27.264874
209	17	Approved	Expert	7	Monthly	Seeded request	2025-11-12 16:30:27.264874
891	6	Approved	Expert	2	Weekly	Seeded assignment	2025-11-28 02:00:27.264874
262	12	Requested	Beginner	4	Monthly	Seeded assignment	2025-11-03 06:23:27.264874
487	20	Approved	Intermediate	1	\N	Seeded assignment	\N
850	17	Approved	Expert	6	\N	Seeded assignment	\N
100	23	Requested	\N	10	\N	Seeded assignment	\N
283	1	Approved	\N	3	\N	Seeded assignment	\N
683	11	Approved	\N	\N	Monthly	Seeded assignment	\N
19	7	Approved	\N	\N	Weekly	Seeded assignment	\N
398	7	Requested	Beginner	\N	\N	Seeded request	2025-11-30 18:37:27.264874
667	25	Requested	Intermediate	\N	\N	Seeded request	\N
130	1	Requested	\N	9	\N	Seeded assignment	2025-11-23 06:34:27.264874
343	21	Approved	\N	\N	\N	Seeded request	\N
548	1	Approved	Advanced	6	Daily	Seeded assignment	\N
729	6	Requested	\N	7	Weekly	Seeded assignment	2025-11-17 01:27:27.264874
258	7	Approved	\N	\N	Monthly	Seeded request	\N
545	20	Approved	Expert	\N	Monthly	Seeded assignment	\N
759	7	Approved	\N	\N	\N	Seeded assignment	2025-11-26 23:38:27.264874
884	9	Approved	Expert	7	\N	Seeded request	\N
507	8	Approved	\N	8	Monthly	Seeded assignment	\N
867	4	Requested	\N	\N	\N	Seeded request	2025-11-15 11:10:27.264874
140	6	Approved	Intermediate	1	\N	Seeded assignment	\N
212	1	Requested	Intermediate	5	Daily	Seeded request	2025-11-18 05:32:27.264874
654	7	Requested	Intermediate	6	\N	Seeded assignment	\N
185	20	Approved	\N	4	Rarely	Seeded request	\N
263	22	Requested	\N	8	Daily	Seeded assignment	\N
775	7	Approved	Beginner	\N	Daily	Seeded request	2025-11-07 10:54:27.264874
173	4	Requested	Beginner	\N	Weekly	Seeded assignment	2025-12-02 09:44:27.264874
149	25	Requested	Intermediate	3	\N	Seeded assignment	2025-11-05 16:27:27.264874
470	11	Approved	Intermediate	\N	Weekly	Seeded request	\N
239	24	Requested	Beginner	2	Monthly	Seeded assignment	\N
704	23	Approved	\N	4	Rarely	Seeded assignment	2025-11-21 23:09:27.264874
876	11	Requested	\N	\N	Weekly	Seeded request	2025-11-22 00:03:27.264874
522	3	Approved	\N	4	\N	Seeded request	\N
211	6	Approved	\N	\N	\N	Seeded assignment	2025-11-15 02:40:27.264874
354	13	Requested	Beginner	5	Rarely	Seeded request	\N
706	25	Requested	Expert	\N	Daily	Seeded assignment	\N
145	21	Requested	\N	\N	\N	Seeded assignment	\N
607	5	Approved	\N	6	Rarely	Seeded request	2025-11-15 08:25:27.264874
144	1	Approved	\N	\N	Monthly	Seeded request	\N
916	9	Approved	Intermediate	\N	Rarely	Seeded request	2025-11-16 12:48:27.264874
246	13	Requested	\N	\N	Daily	Seeded request	\N
541	25	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-06 01:25:27.264874
911	9	Approved	Beginner	2	\N	Seeded assignment	2025-11-26 23:01:27.264874
874	16	Requested	\N	\N	Weekly	Seeded request	\N
156	19	Approved	\N	\N	Daily	Seeded assignment	\N
798	16	Requested	Beginner	8	\N	Seeded assignment	\N
94	11	Approved	Beginner	2	Rarely	Seeded request	\N
699	11	Approved	\N	\N	\N	Seeded request	\N
674	21	Approved	\N	3	Daily	Seeded request	\N
933	22	Approved	\N	\N	Monthly	Seeded assignment	\N
538	4	Requested	\N	\N	Weekly	Seeded request	\N
203	19	Approved	Expert	\N	Daily	Seeded assignment	\N
166	9	Requested	\N	10	\N	Seeded assignment	\N
672	21	Requested	Advanced	7	Monthly	Seeded assignment	2025-11-03 14:36:27.264874
925	4	Requested	Intermediate	10	Rarely	Seeded assignment	\N
543	8	Requested	Beginner	1	\N	Seeded request	\N
26	25	Approved	\N	\N	\N	Seeded assignment	2025-11-06 20:25:27.264874
722	23	Approved	\N	1	\N	Seeded assignment	\N
815	24	Requested	Beginner	1	Monthly	Seeded assignment	\N
931	7	Approved	Intermediate	10	Rarely	Seeded assignment	\N
98	21	Requested	\N	\N	Weekly	Seeded assignment	2025-11-15 00:11:27.264874
97	20	Approved	Intermediate	1	Monthly	Seeded assignment	\N
220	9	Requested	\N	\N	\N	Seeded assignment	\N
604	20	Requested	Beginner	2	\N	Seeded assignment	\N
869	8	Approved	Advanced	\N	\N	Seeded assignment	2025-11-13 09:34:27.264874
51	19	Approved	Expert	2	\N	Seeded assignment	2025-11-14 19:38:27.264874
306	1	Approved	\N	\N	\N	Seeded request	2025-11-11 01:29:27.264874
441	13	Approved	Expert	\N	Daily	Seeded request	\N
805	24	Requested	Expert	3	\N	Seeded assignment	\N
393	13	Approved	\N	4	Weekly	Seeded assignment	\N
842	20	Requested	Expert	4	\N	Seeded assignment	\N
434	20	Requested	\N	1	Weekly	Seeded request	\N
436	1	Approved	\N	2	Weekly	Seeded assignment	2025-11-30 13:35:27.264874
350	13	Approved	\N	\N	Daily	Seeded assignment	\N
383	16	Approved	Expert	9	Rarely	Seeded request	\N
420	1	Approved	\N	\N	\N	Seeded request	\N
62	11	Requested	\N	\N	Rarely	Seeded assignment	\N
146	21	Requested	Expert	10	Daily	Seeded assignment	\N
514	11	Approved	\N	5	Monthly	Seeded assignment	\N
763	21	Requested	Intermediate	0	Daily	Seeded assignment	\N
746	9	Approved	Beginner	\N	\N	Seeded assignment	\N
734	13	Approved	Beginner	\N	\N	Seeded request	\N
370	18	Approved	Beginner	10	\N	Seeded assignment	2025-11-13 02:08:27.264874
217	4	Requested	Expert	3	\N	Seeded request	\N
480	6	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
308	22	Requested	Expert	2	\N	Seeded request	\N
196	25	Approved	\N	\N	\N	Seeded assignment	2025-11-20 01:15:27.264874
219	5	Approved	\N	\N	\N	Seeded assignment	2025-11-24 23:07:27.264874
240	4	Approved	\N	\N	Daily	Seeded request	\N
834	24	Requested	Beginner	10	Monthly	Seeded assignment	\N
183	1	Approved	Beginner	9	\N	Seeded assignment	\N
711	1	Approved	\N	9	\N	Seeded assignment	2025-11-26 10:05:27.264874
584	3	Approved	\N	\N	\N	Seeded request	\N
550	10	Approved	\N	4	\N	Seeded assignment	\N
552	5	Requested	Beginner	\N	Weekly	Seeded request	\N
193	17	Requested	\N	\N	\N	Seeded assignment	\N
235	12	Approved	Intermediate	\N	\N	Seeded assignment	\N
101	21	Approved	Beginner	\N	\N	Seeded request	\N
340	8	Approved	\N	7	Daily	Seeded request	2025-11-11 20:29:27.264874
64	10	Approved	Advanced	8	\N	Seeded assignment	\N
202	6	Requested	Expert	\N	Weekly	Seeded assignment	\N
241	25	Approved	Intermediate	9	\N	Seeded assignment	\N
349	19	Requested	\N	\N	\N	Seeded assignment	\N
661	8	Requested	\N	7	Weekly	Seeded assignment	\N
853	17	Requested	Intermediate	\N	Weekly	Seeded request	\N
17	25	Requested	\N	7	\N	Seeded assignment	2025-11-06 11:26:27.264874
174	1	Approved	Beginner	\N	\N	Seeded assignment	2025-11-17 18:26:27.264874
451	22	Approved	Intermediate	7	Rarely	Seeded assignment	\N
795	19	Approved	Expert	\N	\N	Seeded assignment	2025-11-24 16:11:27.264874
342	4	Requested	Intermediate	5	\N	Seeded assignment	\N
945	9	Requested	Expert	5	Monthly	Seeded request	\N
754	3	Requested	\N	\N	\N	Seeded assignment	\N
426	23	Approved	\N	10	\N	Seeded assignment	2025-12-01 15:34:27.264874
906	9	Approved	Intermediate	6	Rarely	Seeded request	2025-11-30 09:48:27.264874
391	23	Approved	\N	8	\N	Seeded request	\N
857	22	Requested	\N	\N	Monthly	Seeded assignment	2025-11-26 04:54:27.264874
762	5	Approved	Intermediate	9	Rarely	Seeded request	2025-11-19 13:16:27.264874
138	16	Requested	Expert	9	\N	Seeded request	\N
134	11	Approved	Expert	5	Monthly	Seeded request	2025-11-19 04:33:27.264874
415	9	Requested	Expert	6	\N	Seeded assignment	\N
532	7	Requested	\N	8	\N	Seeded assignment	\N
519	8	Requested	Expert	8	\N	Seeded request	\N
300	6	Approved	Expert	\N	\N	Seeded assignment	\N
627	23	Approved	Beginner	\N	\N	Seeded assignment	\N
124	9	Approved	Intermediate	5	Daily	Seeded assignment	2025-11-03 10:13:27.264874
270	21	Approved	\N	\N	Weekly	Seeded assignment	\N
438	19	Requested	\N	\N	\N	Seeded request	2025-11-08 15:05:27.264874
428	17	Requested	\N	\N	Monthly	Seeded assignment	\N
978	3	Approved	Expert	2	Daily	Seeded assignment	2025-11-29 11:29:27.264874
262	5	Requested	Expert	\N	Daily	Seeded request	\N
524	25	Requested	Beginner	1	Daily	Seeded assignment	\N
752	17	Approved	Expert	2	Daily	Seeded assignment	2025-12-02 02:04:27.264874
242	4	Requested	\N	7	Weekly	Seeded request	\N
364	3	Approved	Expert	\N	\N	Seeded assignment	\N
44	1	Requested	Beginner	3	Rarely	Seeded assignment	\N
581	8	Requested	Beginner	10	\N	Seeded assignment	2025-11-08 06:06:27.264874
975	9	Approved	\N	4	Monthly	Seeded request	\N
608	3	Approved	Intermediate	0	\N	Seeded request	\N
619	9	Requested	Intermediate	10	Weekly	Seeded request	\N
334	20	Approved	Intermediate	4	Daily	Seeded assignment	2025-11-05 10:01:27.264874
606	21	Approved	\N	1	Weekly	Seeded assignment	2025-12-02 20:31:27.264874
932	11	Approved	Advanced	\N	Weekly	Seeded assignment	2025-11-23 02:30:27.264874
930	13	Approved	\N	5	\N	Seeded assignment	2025-11-21 18:21:27.264874
552	12	Approved	\N	\N	Monthly	Seeded assignment	\N
739	6	Approved	\N	4	Rarely	Seeded assignment	2025-11-10 02:57:27.264874
870	18	Requested	\N	8	\N	Seeded request	2025-12-01 20:09:27.264874
396	8	Approved	Intermediate	10	Daily	Seeded assignment	\N
113	6	Requested	Intermediate	1	Weekly	Seeded request	2025-11-03 07:41:27.264874
368	16	Approved	Intermediate	\N	Rarely	Seeded assignment	\N
856	21	Approved	Intermediate	4	\N	Seeded assignment	\N
937	8	Requested	Expert	10	\N	Seeded assignment	2025-11-07 06:56:27.264874
110	5	Approved	\N	8	\N	Seeded assignment	\N
79	12	Approved	\N	\N	Daily	Seeded assignment	2025-11-07 10:59:27.264874
348	23	Requested	Intermediate	8	Weekly	Seeded assignment	2025-11-05 10:04:27.264874
707	13	Requested	Advanced	\N	\N	Seeded assignment	\N
799	19	Requested	Expert	\N	Monthly	Seeded assignment	2025-11-22 06:51:27.264874
261	23	Requested	Expert	3	Weekly	Seeded assignment	2025-11-05 03:57:27.264874
74	11	Approved	\N	1	\N	Seeded assignment	\N
289	6	Approved	\N	7	\N	Seeded assignment	2025-11-04 16:42:27.264874
186	17	Approved	\N	6	Daily	Seeded request	2025-11-13 21:52:27.264874
936	4	Requested	\N	\N	Weekly	Seeded assignment	\N
407	16	Approved	\N	\N	Weekly	Seeded assignment	2025-11-25 22:08:27.264874
40	23	Requested	\N	\N	Rarely	Seeded request	\N
182	23	Requested	Advanced	\N	\N	Seeded assignment	2025-11-13 07:13:27.264874
355	23	Approved	\N	3	Rarely	Seeded assignment	\N
904	22	Approved	\N	4	Weekly	Seeded request	\N
892	6	Requested	\N	5	\N	Seeded assignment	\N
90	18	Approved	\N	\N	Daily	Seeded assignment	\N
338	12	Requested	\N	9	Daily	Seeded request	\N
790	3	Requested	\N	\N	\N	Seeded assignment	2025-11-24 20:22:27.264874
489	25	Requested	Beginner	\N	Rarely	Seeded assignment	\N
569	7	Requested	\N	4	\N	Seeded assignment	2025-11-22 19:25:27.264874
525	22	Approved	Expert	\N	\N	Seeded assignment	2025-11-10 10:09:27.264874
510	3	Approved	Expert	5	Daily	Seeded assignment	\N
408	10	Requested	Advanced	6	Daily	Seeded request	\N
950	19	Approved	Beginner	1	Daily	Seeded assignment	2025-11-26 15:58:27.264874
208	1	Approved	Advanced	\N	\N	Seeded request	\N
726	16	Approved	\N	0	\N	Seeded assignment	2025-11-23 15:36:27.264874
484	7	Approved	Intermediate	\N	\N	Seeded assignment	\N
720	11	Approved	Expert	7	Daily	Seeded assignment	2025-11-11 16:47:27.264874
840	11	Requested	\N	6	\N	Seeded request	2025-11-23 15:11:27.264874
894	3	Requested	Expert	6	Daily	Seeded request	2025-11-29 23:22:27.264874
371	16	Approved	Expert	5	Monthly	Seeded request	\N
257	4	Approved	\N	\N	Daily	Seeded request	\N
361	23	Requested	Advanced	9	\N	Seeded request	\N
206	9	Requested	Expert	4	\N	Seeded assignment	2025-11-23 10:32:27.264874
41	11	Requested	\N	7	Weekly	Seeded request	\N
516	11	Approved	\N	\N	\N	Seeded assignment	\N
809	5	Approved	Beginner	\N	\N	Seeded request	2025-11-28 06:50:27.264874
887	21	Approved	Expert	\N	\N	Seeded request	\N
730	7	Approved	Advanced	\N	\N	Seeded request	\N
4	4	Approved	Beginner	\N	\N	Seeded assignment	\N
105	3	Approved	\N	\N	\N	Seeded request	\N
54	22	Approved	Expert	8	\N	Seeded assignment	2025-11-09 02:16:27.264874
780	1	Approved	Expert	5	Daily	Seeded assignment	2025-11-22 16:55:27.264874
464	12	Requested	Intermediate	\N	\N	Seeded request	\N
666	16	Approved	Advanced	2	Rarely	Seeded request	\N
421	8	Approved	Beginner	6	Monthly	Seeded assignment	\N
242	3	Requested	Beginner	\N	Rarely	Seeded assignment	2025-11-09 19:01:27.264874
986	13	Approved	\N	\N	\N	Seeded assignment	\N
190	3	Approved	\N	\N	Monthly	Seeded assignment	\N
384	24	Approved	Intermediate	\N	Weekly	Seeded request	\N
352	18	Requested	Intermediate	2	\N	Seeded request	\N
500	23	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
906	1	Approved	\N	2	Monthly	Seeded request	\N
286	13	Requested	Advanced	\N	Weekly	Seeded assignment	\N
572	4	Approved	Expert	6	Daily	Seeded assignment	\N
479	10	Approved	Expert	\N	Weekly	Seeded request	2025-11-13 00:30:27.264874
648	3	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-08 18:03:27.264874
50	18	Approved	Beginner	4	Weekly	Seeded assignment	2025-11-09 02:43:27.264874
539	3	Approved	Advanced	\N	Rarely	Seeded assignment	\N
108	6	Approved	\N	1	Monthly	Seeded assignment	2025-11-26 00:49:27.264874
93	21	Approved	\N	\N	\N	Seeded request	\N
182	7	Requested	Intermediate	3	Weekly	Seeded assignment	\N
735	18	Requested	Advanced	\N	\N	Seeded assignment	\N
133	8	Approved	Beginner	2	Daily	Seeded request	2025-11-18 19:28:27.264874
279	8	Requested	Beginner	10	Rarely	Seeded assignment	\N
888	3	Approved	\N	5	Daily	Seeded request	2025-11-11 13:51:27.264874
51	18	Approved	\N	\N	Rarely	Seeded assignment	\N
197	13	Requested	Advanced	\N	Rarely	Seeded request	\N
221	6	Requested	\N	1	\N	Seeded assignment	\N
192	20	Approved	Beginner	\N	\N	Seeded request	\N
20	24	Requested	\N	\N	Rarely	Seeded request	2025-11-04 15:34:27.264874
668	1	Requested	\N	1	\N	Seeded assignment	\N
155	5	Approved	Intermediate	4	\N	Seeded assignment	\N
513	18	Approved	Intermediate	3	Daily	Seeded assignment	\N
586	18	Approved	Beginner	\N	Rarely	Seeded assignment	\N
968	11	Requested	Expert	\N	\N	Seeded assignment	2025-11-29 04:18:27.264874
551	19	Requested	Beginner	5	Rarely	Seeded request	\N
528	9	Approved	Beginner	10	\N	Seeded request	2025-11-17 18:38:27.264874
702	13	Approved	Advanced	4	Daily	Seeded request	\N
406	12	Requested	\N	\N	Monthly	Seeded assignment	\N
92	9	Requested	\N	\N	\N	Seeded assignment	2025-11-08 22:29:27.264874
767	13	Approved	Expert	\N	\N	Seeded assignment	2025-11-12 14:28:27.264874
624	25	Approved	Beginner	10	Daily	Seeded request	\N
919	7	Requested	Intermediate	7	Weekly	Seeded request	2025-11-06 17:18:27.264874
203	18	Approved	\N	2	Monthly	Seeded assignment	2025-11-22 04:27:27.264874
529	18	Requested	Advanced	1	\N	Seeded request	\N
831	5	Requested	Intermediate	3	Weekly	Seeded request	\N
49	16	Approved	Advanced	10	\N	Seeded assignment	\N
415	1	Requested	\N	9	\N	Seeded assignment	2025-11-11 22:54:27.264874
691	13	Approved	Intermediate	1	\N	Seeded request	2025-11-16 10:20:27.264874
230	21	Approved	Expert	1	Weekly	Seeded assignment	2025-11-06 22:22:27.264874
618	22	Requested	Expert	\N	\N	Seeded request	\N
69	18	Requested	\N	8	\N	Seeded request	2025-11-03 13:16:27.264874
219	20	Approved	Advanced	5	\N	Seeded request	\N
4	3	Approved	Intermediate	2	Rarely	Seeded assignment	2025-11-05 06:45:27.264874
709	13	Requested	\N	4	Daily	Seeded assignment	\N
939	19	Approved	\N	7	\N	Seeded request	\N
544	1	Approved	Expert	8	Rarely	Seeded assignment	\N
55	8	Requested	\N	9	Weekly	Seeded assignment	2025-11-09 17:32:27.264874
900	17	Approved	Intermediate	8	\N	Seeded assignment	\N
805	10	Approved	Intermediate	2	Weekly	Seeded assignment	2025-11-03 10:52:27.264874
741	7	Requested	\N	10	Rarely	Seeded assignment	2025-11-05 02:39:27.264874
909	4	Approved	Beginner	1	Rarely	Seeded request	\N
127	19	Approved	\N	9	\N	Seeded assignment	2025-11-21 09:33:27.264874
257	3	Approved	Intermediate	\N	\N	Seeded request	2025-11-19 17:45:27.264874
296	25	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-10 11:03:27.264874
45	16	Approved	\N	\N	Rarely	Seeded assignment	\N
374	8	Approved	Expert	2	Monthly	Seeded request	2025-12-02 13:06:27.264874
373	21	Requested	Intermediate	0	Monthly	Seeded assignment	2025-11-20 16:54:27.264874
647	24	Approved	\N	\N	\N	Seeded assignment	2025-11-29 06:22:27.264874
430	18	Requested	\N	10	Monthly	Seeded request	\N
429	6	Approved	\N	9	\N	Seeded assignment	\N
29	20	Approved	\N	10	\N	Seeded assignment	2025-11-19 08:27:27.264874
294	3	Requested	Beginner	\N	Weekly	Seeded request	\N
247	9	Approved	Expert	9	Daily	Seeded assignment	\N
487	5	Requested	\N	1	\N	Seeded assignment	2025-11-26 19:00:27.264874
790	4	Approved	Beginner	4	\N	Seeded request	2025-11-26 13:59:27.264874
829	4	Approved	Advanced	6	\N	Seeded request	2025-11-14 17:06:27.264874
363	13	Approved	\N	1	Monthly	Seeded request	\N
322	9	Requested	Beginner	\N	Rarely	Seeded request	2025-11-23 09:01:27.264874
213	21	Requested	Advanced	10	Weekly	Seeded assignment	2025-11-25 18:07:27.264874
422	16	Approved	\N	0	Weekly	Seeded assignment	\N
299	19	Requested	Expert	1	\N	Seeded assignment	2025-11-15 23:55:27.264874
540	23	Approved	\N	\N	Weekly	Seeded assignment	\N
568	3	Approved	Expert	\N	Weekly	Seeded assignment	\N
316	18	Approved	\N	\N	Weekly	Seeded request	\N
650	3	Approved	Expert	\N	Weekly	Seeded request	2025-11-21 15:43:27.264874
609	6	Requested	Advanced	0	Rarely	Seeded request	\N
696	7	Approved	Beginner	8	Weekly	Seeded request	\N
663	9	Requested	\N	7	Rarely	Seeded assignment	2025-11-28 11:56:27.264874
167	25	Approved	\N	\N	\N	Seeded assignment	2025-11-12 06:56:27.264874
725	8	Approved	Intermediate	0	Monthly	Seeded request	2025-12-02 20:25:27.264874
708	13	Approved	\N	\N	\N	Seeded assignment	\N
810	20	Approved	Advanced	0	Rarely	Seeded assignment	2025-11-28 07:53:27.264874
52	21	Approved	Beginner	\N	Weekly	Seeded assignment	\N
132	4	Approved	\N	9	Daily	Seeded assignment	\N
642	10	Requested	\N	\N	\N	Seeded assignment	2025-11-03 19:57:27.264874
706	6	Approved	Intermediate	2	\N	Seeded assignment	2025-11-20 05:13:27.264874
849	1	Approved	\N	\N	\N	Seeded assignment	\N
814	11	Requested	Beginner	7	\N	Seeded assignment	2025-11-29 23:01:27.264874
602	5	Requested	\N	10	\N	Seeded request	\N
964	4	Requested	Expert	10	Rarely	Seeded assignment	2025-11-25 19:52:27.264874
70	18	Requested	\N	10	\N	Seeded request	\N
59	3	Approved	\N	\N	Rarely	Seeded assignment	\N
225	18	Requested	\N	\N	Weekly	Seeded assignment	\N
15	25	Approved	\N	\N	\N	Seeded request	\N
35	5	Approved	\N	7	Daily	Seeded assignment	2025-11-05 02:54:27.264874
770	10	Requested	Beginner	\N	\N	Seeded request	2025-11-30 13:17:27.264874
866	8	Approved	\N	5	\N	Seeded assignment	\N
140	25	Approved	\N	7	\N	Seeded assignment	\N
77	25	Approved	\N	0	\N	Seeded assignment	2025-11-27 06:51:27.264874
932	9	Requested	\N	5	\N	Seeded assignment	2025-11-06 07:48:27.264874
103	20	Approved	Beginner	3	Daily	Seeded request	2025-12-01 10:34:27.264874
495	12	Approved	Expert	1	\N	Seeded assignment	2025-11-21 17:38:27.264874
149	6	Requested	Expert	1	Rarely	Seeded request	\N
269	16	Requested	\N	\N	Rarely	Seeded assignment	\N
951	16	Approved	\N	\N	Rarely	Seeded request	\N
943	19	Requested	Intermediate	\N	Rarely	Seeded request	\N
890	11	Approved	\N	\N	Weekly	Seeded request	2025-11-06 19:44:27.264874
787	5	Approved	\N	\N	\N	Seeded assignment	2025-11-06 07:06:27.264874
333	17	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-23 05:53:27.264874
503	13	Approved	\N	4	Weekly	Seeded assignment	\N
889	21	Approved	Beginner	\N	\N	Seeded assignment	2025-11-12 12:56:27.264874
414	6	Requested	Expert	1	Monthly	Seeded request	\N
800	17	Requested	Intermediate	0	Rarely	Seeded assignment	2025-11-25 15:53:27.264874
334	22	Approved	Intermediate	4	Weekly	Seeded request	2025-11-24 15:41:27.264874
667	6	Requested	Intermediate	8	Rarely	Seeded assignment	\N
880	17	Requested	Beginner	2	\N	Seeded assignment	2025-11-06 05:58:27.264874
646	24	Approved	Advanced	\N	Weekly	Seeded assignment	\N
902	5	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-24 22:33:27.264874
406	22	Requested	\N	\N	Weekly	Seeded request	\N
777	7	Requested	Beginner	\N	Rarely	Seeded request	\N
111	11	Approved	\N	8	\N	Seeded assignment	\N
786	6	Requested	\N	\N	Monthly	Seeded assignment	\N
894	18	Approved	\N	6	\N	Seeded request	\N
191	23	Requested	\N	\N	Daily	Seeded assignment	\N
954	21	Requested	\N	9	Monthly	Seeded assignment	\N
67	16	Requested	Expert	\N	\N	Seeded request	2025-11-28 00:45:27.264874
475	10	Approved	Expert	2	Rarely	Seeded assignment	2025-11-19 23:29:27.264874
457	16	Requested	\N	5	Rarely	Seeded assignment	2025-11-21 15:57:27.264874
719	10	Requested	Intermediate	8	\N	Seeded request	2025-11-17 00:25:27.264874
554	23	Requested	Advanced	\N	\N	Seeded assignment	\N
249	4	Approved	Advanced	\N	Rarely	Seeded request	\N
196	6	Approved	\N	0	Monthly	Seeded request	\N
817	23	Requested	\N	\N	\N	Seeded assignment	\N
134	9	Approved	Expert	10	\N	Seeded request	\N
302	22	Requested	Expert	3	Monthly	Seeded request	2025-11-29 05:05:27.264874
386	22	Approved	Expert	5	Monthly	Seeded assignment	2025-11-12 14:47:27.264874
573	13	Approved	Advanced	\N	Weekly	Seeded assignment	2025-11-19 19:01:27.264874
481	9	Requested	Beginner	\N	Daily	Seeded request	\N
929	12	Requested	Expert	0	\N	Seeded request	\N
779	23	Approved	\N	6	Weekly	Seeded assignment	\N
612	19	Requested	\N	\N	\N	Seeded assignment	2025-11-08 02:50:27.264874
925	19	Requested	Advanced	2	Rarely	Seeded request	\N
955	16	Requested	Intermediate	10	\N	Seeded request	\N
203	4	Approved	\N	2	\N	Seeded request	2025-11-20 00:10:27.264874
596	10	Approved	\N	3	Rarely	Seeded assignment	\N
945	11	Approved	Expert	10	Monthly	Seeded assignment	\N
351	22	Approved	Advanced	\N	\N	Seeded request	\N
927	7	Requested	Advanced	5	\N	Seeded assignment	2025-11-05 20:58:27.264874
591	9	Requested	\N	\N	Rarely	Seeded request	\N
69	4	Approved	Beginner	3	\N	Seeded assignment	2025-11-06 14:49:27.264874
136	6	Approved	Expert	\N	\N	Seeded request	2025-11-16 19:55:27.264874
731	5	Approved	Advanced	6	\N	Seeded assignment	2025-11-15 00:38:27.264874
394	3	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
793	12	Approved	\N	\N	Rarely	Seeded assignment	2025-12-02 09:12:27.264874
364	18	Requested	Advanced	5	Monthly	Seeded request	\N
848	7	Approved	Expert	5	Rarely	Seeded assignment	2025-11-20 00:55:27.264874
636	25	Requested	\N	2	Daily	Seeded assignment	2025-12-01 16:54:27.264874
703	4	Approved	\N	9	Daily	Seeded assignment	2025-11-17 15:19:27.264874
66	23	Approved	Intermediate	1	Monthly	Seeded request	\N
827	23	Approved	Expert	6	\N	Seeded assignment	\N
698	3	Approved	\N	3	Rarely	Seeded assignment	2025-11-13 17:18:27.264874
141	3	Approved	\N	9	\N	Seeded assignment	2025-11-26 05:20:27.264874
229	11	Approved	Intermediate	\N	\N	Seeded assignment	\N
860	18	Approved	Beginner	\N	Weekly	Seeded assignment	\N
291	13	Requested	Advanced	3	\N	Seeded request	\N
86	12	Requested	\N	3	Monthly	Seeded assignment	2025-11-21 22:35:27.264874
224	4	Approved	Advanced	7	\N	Seeded assignment	\N
255	23	Approved	Beginner	\N	\N	Seeded request	\N
34	7	Approved	Expert	\N	Monthly	Seeded request	2025-11-07 01:09:27.264874
124	11	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-04 09:09:27.264874
486	8	Requested	Intermediate	\N	Weekly	Seeded assignment	2025-11-20 10:34:27.264874
247	11	Approved	\N	\N	\N	Seeded assignment	2025-11-03 09:15:27.264874
7	5	Approved	Beginner	6	Weekly	Seeded assignment	\N
201	19	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
263	5	Approved	Advanced	3	Monthly	Seeded assignment	2025-11-13 07:24:27.264874
557	16	Requested	Intermediate	\N	Weekly	Seeded assignment	2025-11-18 06:19:27.264874
81	16	Requested	\N	9	\N	Seeded assignment	\N
932	1	Approved	\N	1	Weekly	Seeded request	\N
393	16	Requested	Intermediate	\N	Rarely	Seeded assignment	2025-11-15 17:46:27.264874
303	25	Requested	Expert	\N	Rarely	Seeded assignment	\N
437	6	Approved	\N	10	Monthly	Seeded request	\N
88	13	Approved	Intermediate	8	\N	Seeded assignment	\N
466	23	Approved	Expert	6	\N	Seeded request	\N
257	18	Requested	\N	6	Daily	Seeded assignment	\N
451	12	Approved	Intermediate	\N	Daily	Seeded request	\N
256	21	Approved	Advanced	\N	Monthly	Seeded request	2025-11-07 14:20:27.264874
607	22	Approved	Beginner	6	Monthly	Seeded assignment	\N
631	10	Requested	Beginner	3	Monthly	Seeded assignment	2025-11-27 11:35:27.264874
745	8	Approved	\N	10	Weekly	Seeded request	\N
156	3	Approved	\N	\N	Weekly	Seeded assignment	2025-11-17 10:23:27.264874
764	9	Approved	\N	\N	\N	Seeded assignment	\N
139	23	Approved	\N	\N	\N	Seeded assignment	\N
614	23	Approved	Expert	\N	\N	Seeded assignment	\N
456	21	Approved	Intermediate	1	\N	Seeded assignment	2025-12-01 22:06:27.264874
53	12	Requested	Advanced	\N	Monthly	Seeded assignment	2025-11-07 05:19:27.264874
143	23	Approved	Advanced	7	\N	Seeded request	2025-11-10 12:59:27.264874
613	18	Approved	Intermediate	0	Rarely	Seeded request	\N
89	7	Approved	\N	7	\N	Seeded request	2025-11-22 09:04:27.264874
317	24	Requested	Expert	1	\N	Seeded assignment	\N
830	22	Approved	\N	\N	Daily	Seeded assignment	2025-11-18 11:46:27.264874
827	7	Requested	\N	1	\N	Seeded assignment	2025-11-21 20:45:27.264874
297	17	Requested	\N	\N	\N	Seeded assignment	2025-11-04 06:43:27.264874
949	23	Approved	\N	2	Weekly	Seeded request	\N
34	23	Approved	Intermediate	7	Daily	Seeded assignment	\N
42	4	Approved	Advanced	\N	\N	Seeded request	2025-11-26 17:14:27.264874
255	7	Requested	Intermediate	\N	\N	Seeded request	\N
771	19	Approved	Intermediate	2	Weekly	Seeded request	2025-11-21 03:33:27.264874
580	1	Requested	\N	\N	Daily	Seeded assignment	\N
973	9	Requested	\N	\N	Rarely	Seeded assignment	2025-11-21 00:25:27.264874
90	4	Requested	Intermediate	8	Rarely	Seeded request	2025-11-07 16:54:27.264874
660	3	Approved	Intermediate	4	\N	Seeded request	\N
27	8	Requested	\N	0	Daily	Seeded request	2025-11-13 18:17:27.264874
841	10	Requested	\N	5	\N	Seeded assignment	2025-11-10 02:23:27.264874
450	22	Requested	Advanced	2	Daily	Seeded assignment	2025-11-03 15:03:27.264874
463	4	Requested	\N	\N	\N	Seeded request	2025-11-12 19:12:27.264874
123	17	Requested	Intermediate	0	\N	Seeded assignment	2025-11-25 23:46:27.264874
189	25	Requested	\N	3	\N	Seeded assignment	2025-11-13 15:56:27.264874
496	6	Approved	\N	3	Daily	Seeded assignment	2025-11-06 23:06:27.264874
698	4	Approved	Advanced	0	Monthly	Seeded request	\N
210	19	Approved	Expert	6	\N	Seeded request	\N
875	21	Approved	Beginner	10	\N	Seeded assignment	\N
885	17	Approved	\N	\N	Rarely	Seeded assignment	\N
102	23	Approved	Advanced	10	Rarely	Seeded assignment	2025-11-28 04:48:27.264874
898	23	Approved	Advanced	\N	Weekly	Seeded assignment	\N
416	21	Approved	\N	4	Monthly	Seeded request	2025-11-04 01:13:27.264874
618	20	Requested	Intermediate	10	\N	Seeded assignment	2025-12-03 01:03:27.264874
703	3	Approved	\N	7	\N	Seeded assignment	\N
593	24	Requested	\N	1	Weekly	Seeded assignment	2025-11-27 20:51:27.264874
354	16	Requested	Intermediate	3	Rarely	Seeded assignment	2025-11-10 21:33:27.264874
527	5	Requested	\N	\N	\N	Seeded request	\N
773	5	Approved	\N	5	\N	Seeded assignment	\N
783	5	Requested	\N	1	\N	Seeded assignment	2025-11-04 04:22:27.264874
933	5	Approved	Advanced	\N	Monthly	Seeded assignment	\N
228	7	Requested	\N	\N	Daily	Seeded request	2025-11-13 18:57:27.264874
54	12	Requested	Beginner	3	Daily	Seeded request	2025-11-28 04:44:27.264874
246	16	Approved	Expert	1	\N	Seeded request	2025-11-23 01:03:27.264874
859	19	Approved	Advanced	\N	Rarely	Seeded assignment	\N
203	3	Approved	Expert	\N	Weekly	Seeded request	2025-11-10 10:55:27.264874
529	3	Requested	Beginner	\N	Rarely	Seeded request	\N
251	6	Approved	Expert	0	Monthly	Seeded assignment	2025-11-26 21:27:27.264874
44	11	Approved	\N	\N	Weekly	Seeded request	2025-11-10 09:44:27.264874
656	24	Approved	Beginner	\N	Weekly	Seeded assignment	\N
375	5	Approved	\N	6	Daily	Seeded request	\N
418	4	Approved	Expert	\N	Rarely	Seeded request	2025-11-27 23:26:27.264874
191	7	Requested	\N	3	Monthly	Seeded request	\N
85	21	Approved	\N	\N	Monthly	Seeded assignment	2025-11-08 10:41:27.264874
513	3	Approved	Advanced	\N	Rarely	Seeded request	\N
586	3	Approved	\N	\N	Weekly	Seeded assignment	\N
51	3	Approved	\N	9	Monthly	Seeded request	\N
846	24	Approved	Advanced	10	\N	Seeded request	\N
271	22	Approved	\N	\N	Rarely	Seeded request	2025-11-08 22:05:27.264874
806	17	Requested	\N	\N	\N	Seeded request	2025-11-06 20:50:27.264874
879	25	Approved	\N	3	\N	Seeded request	2025-11-12 23:02:27.264874
338	22	Requested	\N	\N	Monthly	Seeded assignment	\N
546	21	Requested	Beginner	\N	\N	Seeded request	\N
55	10	Approved	Expert	7	Weekly	Seeded request	2025-11-20 06:25:27.264874
637	17	Requested	Intermediate	6	Daily	Seeded assignment	\N
605	9	Approved	Beginner	7	\N	Seeded request	\N
710	9	Requested	Advanced	\N	Monthly	Seeded assignment	\N
99	1	Requested	Advanced	\N	\N	Seeded request	\N
707	16	Requested	Beginner	\N	Weekly	Seeded assignment	2025-11-08 20:20:27.264874
768	19	Requested	\N	\N	Daily	Seeded assignment	\N
169	20	Approved	\N	5	\N	Seeded assignment	2025-11-23 04:12:27.264874
626	6	Requested	Expert	\N	Weekly	Seeded assignment	\N
805	8	Requested	Beginner	9	Daily	Seeded assignment	2025-11-05 20:53:27.264874
448	11	Approved	\N	5	Monthly	Seeded request	2025-12-01 16:38:27.264874
885	21	Approved	\N	\N	Weekly	Seeded request	\N
877	4	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-07 06:38:27.264874
833	8	Requested	Advanced	\N	Weekly	Seeded assignment	2025-11-26 02:15:27.264874
362	1	Approved	\N	\N	Rarely	Seeded request	2025-11-18 15:15:27.264874
758	17	Approved	Advanced	\N	Daily	Seeded request	\N
908	18	Approved	Advanced	2	Rarely	Seeded request	2025-11-12 03:06:27.264874
572	19	Requested	Intermediate	0	\N	Seeded assignment	\N
699	1	Approved	Expert	\N	Monthly	Seeded assignment	\N
306	11	Approved	Advanced	\N	\N	Seeded assignment	\N
439	3	Approved	\N	9	Monthly	Seeded request	\N
811	9	Requested	Advanced	\N	\N	Seeded request	\N
530	25	Approved	Beginner	10	\N	Seeded request	2025-11-23 05:24:27.264874
262	22	Requested	\N	\N	\N	Seeded request	2025-11-17 10:35:27.264874
427	17	Approved	Intermediate	\N	Daily	Seeded assignment	\N
588	6	Approved	Advanced	\N	Weekly	Seeded request	\N
24	17	Requested	\N	\N	Daily	Seeded request	2025-11-18 04:48:27.264874
368	13	Approved	\N	\N	Monthly	Seeded assignment	\N
608	19	Approved	\N	7	Weekly	Seeded assignment	2025-11-04 19:34:27.264874
907	11	Approved	Advanced	\N	Daily	Seeded assignment	\N
693	4	Approved	\N	\N	\N	Seeded request	\N
642	24	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-27 13:55:27.264874
946	21	Requested	Beginner	5	\N	Seeded assignment	\N
971	16	Approved	Beginner	\N	Rarely	Seeded request	2025-11-15 04:52:27.264874
53	5	Approved	Expert	3	Rarely	Seeded request	\N
377	17	Approved	Expert	10	Daily	Seeded assignment	\N
924	20	Requested	\N	\N	Daily	Seeded assignment	\N
882	8	Approved	Intermediate	2	Monthly	Seeded request	2025-11-27 18:22:27.264874
32	17	Approved	\N	\N	Rarely	Seeded assignment	2025-11-17 07:46:27.264874
726	13	Approved	\N	1	Monthly	Seeded assignment	2025-11-24 19:01:27.264874
353	10	Approved	\N	1	Monthly	Seeded assignment	2025-11-15 23:57:27.264874
985	4	Requested	Intermediate	6	\N	Seeded assignment	2025-11-09 10:07:27.264874
85	17	Requested	Beginner	1	Rarely	Seeded assignment	2025-11-27 00:30:27.264874
571	16	Approved	Intermediate	\N	\N	Seeded request	2025-12-01 22:32:27.264874
765	7	Approved	Advanced	6	\N	Seeded request	2025-11-13 07:53:27.264874
475	24	Approved	\N	1	Monthly	Seeded request	2025-11-15 18:35:27.264874
508	8	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
925	18	Requested	\N	3	Monthly	Seeded assignment	\N
152	24	Approved	Beginner	\N	Daily	Seeded assignment	2025-11-20 19:35:27.264874
309	3	Requested	\N	9	\N	Seeded assignment	2025-11-27 06:45:27.264874
183	11	Approved	Beginner	1	Rarely	Seeded assignment	\N
917	11	Approved	\N	4	Rarely	Seeded assignment	\N
36	5	Requested	Beginner	3	Rarely	Seeded request	\N
304	21	Approved	Expert	\N	Weekly	Seeded request	\N
762	22	Requested	Beginner	\N	\N	Seeded assignment	\N
120	23	Approved	Advanced	8	Rarely	Seeded assignment	\N
970	21	Approved	Intermediate	10	Daily	Seeded assignment	2025-11-24 11:55:27.264874
471	8	Requested	Intermediate	\N	Monthly	Seeded request	2025-11-12 10:57:27.264874
560	9	Requested	\N	4	Weekly	Seeded assignment	\N
670	9	Approved	Advanced	\N	Monthly	Seeded request	\N
881	22	Approved	\N	4	Weekly	Seeded assignment	\N
525	5	Approved	\N	\N	Weekly	Seeded request	\N
375	12	Approved	\N	\N	\N	Seeded assignment	\N
410	13	Approved	\N	3	Monthly	Seeded assignment	\N
988	9	Approved	\N	5	Rarely	Seeded request	\N
473	21	Approved	\N	\N	\N	Seeded assignment	\N
479	8	Requested	Advanced	\N	Weekly	Seeded assignment	\N
95	16	Approved	\N	6	\N	Seeded request	2025-11-07 01:12:27.264874
268	23	Requested	Advanced	3	Monthly	Seeded assignment	2025-11-29 09:13:27.264874
347	13	Approved	Advanced	\N	\N	Seeded request	2025-11-17 05:51:27.264874
563	8	Approved	Advanced	5	Monthly	Seeded assignment	\N
689	21	Approved	\N	\N	Monthly	Seeded assignment	\N
216	17	Approved	\N	\N	Rarely	Seeded assignment	\N
380	13	Approved	Expert	\N	Rarely	Seeded assignment	2025-11-21 07:57:27.264874
527	12	Approved	\N	7	Rarely	Seeded assignment	\N
512	8	Approved	Beginner	3	\N	Seeded request	\N
783	12	Approved	\N	2	Weekly	Seeded assignment	\N
896	25	Requested	Expert	\N	Weekly	Seeded assignment	\N
609	25	Requested	Advanced	\N	Daily	Seeded assignment	2025-11-29 19:59:27.264874
121	20	Approved	\N	\N	\N	Seeded request	2025-11-15 21:35:27.264874
399	23	Approved	Beginner	0	\N	Seeded request	2025-11-27 22:51:27.264874
634	20	Requested	\N	8	\N	Seeded request	\N
876	1	Approved	\N	0	\N	Seeded assignment	\N
133	10	Requested	\N	\N	Weekly	Seeded request	\N
943	18	Requested	\N	\N	\N	Seeded assignment	2025-11-22 23:23:27.264874
470	1	Approved	\N	\N	\N	Seeded assignment	\N
429	25	Approved	Advanced	6	Daily	Seeded assignment	\N
732	4	Requested	\N	5	\N	Seeded assignment	\N
751	16	Approved	\N	\N	Rarely	Seeded assignment	2025-11-22 22:53:27.264874
492	10	Approved	Advanced	8	\N	Seeded assignment	\N
858	5	Requested	Advanced	7	\N	Seeded assignment	\N
447	3	Approved	Expert	2	Rarely	Seeded assignment	\N
902	20	Requested	Expert	1	Daily	Seeded assignment	2025-12-01 19:03:27.264874
615	11	Approved	Beginner	1	Rarely	Seeded request	\N
776	20	Approved	Advanced	7	\N	Seeded assignment	2025-11-11 02:34:27.264874
705	21	Approved	\N	\N	\N	Seeded assignment	2025-11-27 09:43:27.264874
697	9	Approved	\N	\N	\N	Seeded assignment	\N
456	17	Requested	\N	4	\N	Seeded request	2025-11-11 01:44:27.264874
728	17	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-23 12:23:27.264874
171	5	Requested	Expert	\N	\N	Seeded assignment	\N
260	12	Requested	\N	1	Rarely	Seeded request	2025-11-30 12:24:27.264874
727	21	Approved	Intermediate	0	Monthly	Seeded assignment	2025-11-14 07:42:27.264874
685	22	Requested	\N	\N	Weekly	Seeded assignment	2025-11-15 06:49:27.264874
172	10	Approved	\N	1	\N	Seeded assignment	\N
344	20	Requested	Intermediate	\N	Rarely	Seeded request	\N
175	1	Requested	Advanced	2	Weekly	Seeded assignment	\N
63	20	Approved	Advanced	\N	Rarely	Seeded assignment	\N
494	25	Approved	Beginner	\N	Weekly	Seeded assignment	2025-12-01 05:44:27.264874
671	13	Approved	\N	3	Daily	Seeded request	2025-11-25 01:36:27.264874
524	6	Approved	\N	\N	Weekly	Seeded assignment	\N
181	21	Requested	\N	\N	\N	Seeded assignment	\N
179	3	Approved	Intermediate	0	Monthly	Seeded request	2025-11-03 20:44:27.264874
155	22	Requested	Advanced	\N	Monthly	Seeded assignment	\N
68	25	Approved	Advanced	3	Rarely	Seeded assignment	2025-11-06 12:33:27.264874
687	24	Approved	Advanced	7	\N	Seeded assignment	2025-11-11 05:40:27.264874
910	23	Approved	Expert	\N	\N	Seeded assignment	2025-11-12 11:11:27.264874
476	18	Approved	Expert	4	Rarely	Seeded assignment	\N
690	17	Approved	Beginner	1	\N	Seeded request	\N
935	10	Approved	\N	10	Rarely	Seeded assignment	\N
644	6	Approved	Beginner	4	\N	Seeded assignment	\N
342	19	Requested	Beginner	\N	\N	Seeded request	\N
309	4	Approved	Advanced	\N	Weekly	Seeded assignment	\N
873	12	Approved	\N	\N	\N	Seeded assignment	2025-11-23 04:25:27.264874
199	13	Approved	Intermediate	4	\N	Seeded assignment	\N
659	18	Requested	\N	\N	Monthly	Seeded assignment	\N
549	7	Approved	Expert	\N	\N	Seeded assignment	2025-11-13 20:36:27.264874
83	24	Requested	Advanced	1	\N	Seeded request	2025-11-24 17:45:27.264874
287	21	Approved	Expert	\N	Monthly	Seeded request	2025-12-01 22:30:27.264874
417	1	Requested	\N	3	Weekly	Seeded request	\N
669	16	Approved	Expert	\N	\N	Seeded request	\N
985	3	Approved	Advanced	3	Rarely	Seeded request	\N
852	7	Approved	Beginner	3	\N	Seeded request	\N
517	19	Requested	\N	\N	\N	Seeded assignment	2025-11-18 18:00:27.264874
527	20	Requested	Advanced	3	Rarely	Seeded request	2025-11-14 05:50:27.264874
861	6	Requested	\N	\N	Monthly	Seeded assignment	\N
708	16	Approved	\N	10	\N	Seeded assignment	\N
210	18	Approved	Advanced	\N	\N	Seeded request	2025-11-09 14:49:27.264874
390	9	Approved	Intermediate	\N	\N	Seeded request	2025-11-07 21:57:27.264874
363	16	Approved	\N	6	\N	Seeded request	2025-11-28 12:03:27.264874
635	10	Requested	\N	1	Monthly	Seeded assignment	\N
375	20	Approved	Advanced	10	Daily	Seeded assignment	2025-11-12 06:05:27.264874
388	11	Approved	Expert	\N	Monthly	Seeded assignment	\N
325	6	Approved	\N	8	Monthly	Seeded assignment	2025-11-03 06:37:27.264874
514	9	Requested	\N	\N	\N	Seeded request	2025-11-29 03:44:27.264874
987	25	Requested	\N	6	Weekly	Seeded request	2025-11-12 22:12:27.264874
187	1	Requested	\N	\N	\N	Seeded assignment	\N
865	25	Requested	Expert	4	Rarely	Seeded request	\N
639	1	Requested	Beginner	\N	\N	Seeded assignment	\N
185	22	Approved	Beginner	5	\N	Seeded assignment	\N
555	23	Approved	Expert	7	Weekly	Seeded request	\N
482	12	Approved	Beginner	\N	\N	Seeded assignment	2025-11-24 15:31:27.264874
80	9	Requested	Advanced	0	\N	Seeded assignment	\N
974	6	Approved	Expert	10	\N	Seeded assignment	\N
568	19	Approved	\N	4	\N	Seeded assignment	2025-11-16 14:35:27.264874
661	10	Requested	\N	9	Monthly	Seeded assignment	\N
598	11	Approved	Beginner	10	\N	Seeded assignment	\N
589	17	Approved	\N	\N	Weekly	Seeded assignment	\N
263	20	Requested	Advanced	\N	Daily	Seeded assignment	\N
1	13	Requested	Advanced	3	\N	Seeded assignment	2025-11-03 22:27:27.264874
447	4	Requested	\N	\N	Rarely	Seeded assignment	\N
988	1	Approved	Expert	3	\N	Seeded assignment	\N
676	16	Requested	Advanced	0	Weekly	Seeded request	\N
821	3	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
967	3	Approved	\N	\N	Rarely	Seeded assignment	\N
924	12	Requested	Beginner	1	\N	Seeded request	\N
22	13	Requested	Expert	9	\N	Seeded assignment	\N
315	8	Requested	\N	\N	Monthly	Seeded assignment	2025-11-16 05:52:27.264874
651	24	Requested	\N	5	\N	Seeded request	2025-11-20 02:58:27.264874
319	17	Approved	Beginner	\N	\N	Seeded assignment	\N
656	10	Requested	\N	6	Monthly	Seeded request	2025-11-24 04:23:27.264874
254	10	Requested	Advanced	\N	\N	Seeded request	2025-11-21 07:11:27.264874
911	11	Approved	\N	\N	Weekly	Seeded request	2025-11-12 01:41:27.264874
716	11	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
916	11	Approved	Beginner	7	\N	Seeded assignment	\N
892	25	Requested	\N	\N	Rarely	Seeded assignment	\N
404	21	Approved	\N	\N	Rarely	Seeded request	\N
920	18	Requested	Expert	\N	Rarely	Seeded assignment	\N
372	13	Requested	Intermediate	\N	Rarely	Seeded request	2025-11-22 16:29:27.264874
412	24	Requested	\N	5	\N	Seeded assignment	\N
294	19	Approved	\N	2	Rarely	Seeded assignment	\N
803	25	Approved	\N	10	\N	Seeded assignment	2025-11-18 02:16:27.264874
739	25	Requested	Expert	\N	\N	Seeded request	\N
876	9	Requested	Intermediate	10	\N	Seeded request	2025-11-10 07:35:27.264874
120	7	Approved	Expert	\N	Rarely	Seeded assignment	\N
201	18	Requested	\N	\N	\N	Seeded request	\N
545	22	Approved	\N	10	Weekly	Seeded assignment	2025-11-27 02:55:27.264874
113	25	Approved	Advanced	0	Monthly	Seeded request	\N
960	5	Approved	Intermediate	1	Daily	Seeded request	\N
76	21	Approved	Expert	0	\N	Seeded request	\N
75	6	Approved	Expert	\N	\N	Seeded request	\N
164	3	Requested	Intermediate	0	Daily	Seeded assignment	\N
284	13	Approved	\N	\N	Rarely	Seeded assignment	\N
94	25	Approved	Expert	7	Monthly	Seeded assignment	2025-11-06 17:45:27.264874
479	13	Approved	Intermediate	10	Weekly	Seeded request	\N
561	6	Requested	Expert	6	Rarely	Seeded assignment	\N
889	22	Approved	\N	4	Weekly	Seeded assignment	\N
415	6	Requested	Intermediate	10	Daily	Seeded assignment	2025-11-30 15:50:27.264874
850	20	Requested	\N	\N	Weekly	Seeded request	2025-11-15 21:07:27.264874
969	12	Approved	\N	10	\N	Seeded request	\N
565	9	Requested	\N	\N	Daily	Seeded assignment	2025-11-06 03:31:27.264874
630	20	Requested	Intermediate	10	Weekly	Seeded assignment	\N
676	10	Approved	Expert	\N	Monthly	Seeded assignment	\N
845	21	Approved	Advanced	\N	Weekly	Seeded request	2025-11-19 01:26:27.264874
979	16	Approved	\N	1	Monthly	Seeded request	\N
530	1	Approved	\N	\N	\N	Seeded assignment	\N
3	23	Approved	Intermediate	5	Rarely	Seeded request	2025-11-10 03:55:27.264874
455	20	Approved	\N	\N	\N	Seeded assignment	2025-11-26 01:38:27.264874
465	13	Requested	Beginner	6	Daily	Seeded request	\N
538	7	Approved	Advanced	6	\N	Seeded request	\N
158	3	Requested	Expert	\N	Weekly	Seeded request	2025-12-01 06:59:27.264874
217	7	Approved	Beginner	4	\N	Seeded request	2025-11-22 17:10:27.264874
733	18	Requested	Expert	8	Rarely	Seeded assignment	\N
18	19	Requested	Beginner	\N	\N	Seeded assignment	\N
498	4	Requested	Beginner	8	Monthly	Seeded assignment	2025-11-07 10:19:27.264874
625	16	Approved	Beginner	10	Daily	Seeded request	\N
33	5	Requested	\N	4	Monthly	Seeded request	\N
202	9	Approved	\N	4	Monthly	Seeded assignment	\N
767	10	Approved	Expert	\N	\N	Seeded assignment	2025-11-08 17:14:27.264874
980	5	Approved	Advanced	\N	\N	Seeded request	2025-11-18 15:25:27.264874
139	19	Requested	\N	\N	Rarely	Seeded request	\N
57	13	Approved	Expert	\N	Weekly	Seeded assignment	2025-11-18 19:02:27.264874
205	10	Requested	\N	4	Daily	Seeded request	\N
589	22	Requested	Advanced	3	Daily	Seeded request	2025-11-30 11:50:27.264874
641	10	Approved	Beginner	\N	Weekly	Seeded request	2025-11-15 18:51:27.264874
780	6	Requested	Advanced	\N	\N	Seeded assignment	\N
826	21	Approved	\N	3	Daily	Seeded assignment	2025-11-21 18:39:27.264874
114	10	Approved	Beginner	\N	Weekly	Seeded request	2025-11-11 12:52:27.264874
825	18	Requested	\N	7	Monthly	Seeded assignment	2025-11-16 08:51:27.264874
185	17	Requested	Expert	5	\N	Seeded request	\N
750	10	Requested	Intermediate	0	Monthly	Seeded request	2025-11-18 19:47:27.264874
678	8	Approved	\N	\N	Daily	Seeded request	2025-11-16 07:20:27.264874
100	3	Approved	\N	4	Weekly	Seeded assignment	2025-11-21 01:25:27.264874
197	10	Approved	\N	7	Daily	Seeded assignment	2025-11-26 23:08:27.264874
298	22	Approved	Beginner	\N	Rarely	Seeded assignment	2025-11-04 08:02:27.264874
398	4	Approved	\N	3	Daily	Seeded assignment	\N
604	17	Approved	Expert	1	\N	Seeded request	2025-11-12 18:08:27.264874
97	17	Requested	Beginner	\N	\N	Seeded request	\N
295	13	Approved	\N	\N	Daily	Seeded assignment	2025-11-05 10:00:27.264874
11	13	Requested	\N	9	\N	Seeded assignment	2025-11-15 19:29:27.264874
701	9	Approved	Expert	8	Monthly	Seeded assignment	\N
961	17	Approved	Advanced	\N	Rarely	Seeded request	\N
367	22	Approved	Beginner	\N	Monthly	Seeded assignment	2025-11-05 09:37:27.264874
922	21	Requested	Advanced	\N	\N	Seeded assignment	\N
675	10	Approved	Beginner	4	Monthly	Seeded assignment	\N
265	18	Approved	Beginner	7	Monthly	Seeded request	\N
506	21	Approved	\N	\N	Weekly	Seeded assignment	2025-11-27 19:06:27.264874
557	24	Approved	\N	\N	Monthly	Seeded assignment	\N
796	19	Approved	\N	0	\N	Seeded request	\N
72	19	Requested	\N	\N	Rarely	Seeded assignment	\N
414	11	Approved	Beginner	\N	\N	Seeded assignment	2025-11-09 23:21:27.264874
709	10	Approved	Advanced	1	Rarely	Seeded assignment	\N
336	21	Requested	Beginner	2	Daily	Seeded assignment	2025-11-29 05:17:27.264874
119	20	Approved	\N	\N	\N	Seeded assignment	2025-11-12 10:39:27.264874
493	4	Approved	\N	7	Weekly	Seeded assignment	\N
386	21	Requested	\N	7	Weekly	Seeded request	\N
890	6	Requested	Intermediate	8	Daily	Seeded assignment	\N
307	11	Approved	Expert	4	\N	Seeded assignment	\N
582	19	Approved	\N	9	Monthly	Seeded assignment	\N
168	18	Requested	Expert	\N	Weekly	Seeded assignment	\N
739	9	Approved	Beginner	7	Monthly	Seeded request	\N
619	6	Requested	Beginner	1	\N	Seeded assignment	\N
921	20	Requested	Advanced	10	Rarely	Seeded request	\N
892	9	Approved	\N	\N	Daily	Seeded request	\N
734	24	Approved	\N	\N	Monthly	Seeded request	\N
508	13	Requested	Intermediate	\N	Daily	Seeded request	\N
690	22	Requested	Expert	8	Daily	Seeded assignment	\N
774	5	Approved	Beginner	\N	Daily	Seeded assignment	2025-11-11 05:40:27.264874
363	10	Approved	Expert	10	Weekly	Seeded assignment	\N
175	25	Requested	Advanced	4	Weekly	Seeded request	2025-11-15 17:39:27.264874
587	17	Requested	\N	8	\N	Seeded assignment	2025-11-15 21:04:27.264874
621	24	Approved	Beginner	\N	Rarely	Seeded assignment	2025-11-21 20:57:27.264874
722	3	Approved	Expert	\N	Weekly	Seeded assignment	2025-11-18 23:44:27.264874
476	23	Approved	Expert	\N	Daily	Seeded assignment	\N
775	4	Approved	Expert	10	Weekly	Seeded assignment	2025-11-28 23:05:27.264874
694	1	Approved	Advanced	\N	Rarely	Seeded assignment	\N
100	4	Requested	\N	5	\N	Seeded assignment	2025-11-14 22:04:27.264874
542	17	Requested	\N	1	Monthly	Seeded request	2025-11-28 22:40:27.264874
685	17	Requested	\N	2	Rarely	Seeded assignment	\N
807	18	Approved	\N	\N	Daily	Seeded assignment	\N
264	11	Approved	\N	6	Rarely	Seeded assignment	\N
58	8	Requested	Intermediate	6	Monthly	Seeded assignment	2025-11-04 14:21:27.264874
567	24	Approved	\N	\N	Rarely	Seeded assignment	\N
110	17	Requested	Advanced	\N	Monthly	Seeded assignment	2025-11-05 21:08:27.264874
872	12	Requested	Beginner	9	Monthly	Seeded request	\N
151	12	Approved	\N	\N	Weekly	Seeded assignment	\N
95	10	Approved	\N	4	\N	Seeded request	2025-11-15 05:32:27.264874
662	19	Approved	\N	\N	Monthly	Seeded request	2025-12-02 08:39:27.264874
533	5	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
605	25	Requested	Beginner	2	Monthly	Seeded assignment	\N
64	13	Approved	\N	\N	\N	Seeded assignment	\N
119	12	Approved	\N	\N	Rarely	Seeded assignment	\N
356	10	Requested	\N	\N	\N	Seeded assignment	\N
659	7	Approved	Beginner	7	\N	Seeded assignment	\N
623	10	Approved	Expert	8	Weekly	Seeded request	\N
372	8	Approved	Expert	4	Monthly	Seeded assignment	\N
496	11	Approved	Expert	10	Rarely	Seeded assignment	2025-11-22 21:36:27.264874
65	9	Approved	\N	\N	Monthly	Seeded assignment	2025-11-22 04:44:27.264874
234	13	Requested	Intermediate	0	\N	Seeded assignment	\N
235	21	Approved	Advanced	\N	\N	Seeded assignment	2025-11-20 06:11:27.264874
881	17	Approved	\N	\N	\N	Seeded assignment	\N
145	5	Approved	\N	\N	\N	Seeded request	\N
256	22	Requested	Intermediate	\N	Daily	Seeded request	2025-11-15 21:59:27.264874
784	23	Approved	Beginner	6	Monthly	Seeded request	\N
643	9	Approved	Beginner	3	\N	Seeded request	2025-11-23 22:02:27.264874
82	20	Approved	\N	9	Weekly	Seeded request	\N
931	3	Requested	Expert	10	\N	Seeded assignment	2025-11-20 16:46:27.264874
22	8	Approved	Advanced	0	Daily	Seeded assignment	\N
315	13	Approved	\N	1	\N	Seeded request	\N
865	1	Approved	\N	8	Monthly	Seeded assignment	\N
836	18	Requested	Intermediate	5	Daily	Seeded assignment	2025-11-27 00:31:27.264874
722	4	Approved	Advanced	7	\N	Seeded request	2025-11-13 15:04:27.264874
374	16	Approved	\N	\N	\N	Seeded assignment	\N
55	16	Approved	\N	\N	\N	Seeded request	\N
358	1	Requested	Advanced	7	Weekly	Seeded request	2025-11-07 23:33:27.264874
707	10	Requested	\N	1	\N	Seeded request	\N
654	3	Approved	\N	8	\N	Seeded assignment	2025-11-21 19:04:27.264874
199	8	Requested	Advanced	0	Monthly	Seeded request	\N
324	13	Requested	Beginner	7	Daily	Seeded request	\N
170	16	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-05 09:19:27.264874
674	5	Approved	Beginner	\N	Weekly	Seeded assignment	\N
271	21	Approved	Expert	3	\N	Seeded request	\N
243	5	Approved	\N	4	\N	Seeded assignment	2025-11-12 06:21:27.264874
988	25	Requested	\N	\N	Weekly	Seeded assignment	\N
670	25	Approved	Expert	\N	\N	Seeded assignment	\N
128	16	Approved	Intermediate	7	Rarely	Seeded request	\N
493	3	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
612	23	Approved	Advanced	2	Daily	Seeded assignment	2025-11-14 13:43:27.264874
60	8	Approved	Expert	1	\N	Seeded assignment	2025-11-14 00:46:27.264874
24	22	Approved	Advanced	\N	\N	Seeded assignment	\N
289	1	Approved	\N	\N	Rarely	Seeded assignment	2025-11-08 18:52:27.264874
184	22	Requested	\N	5	Daily	Seeded request	2025-11-28 09:54:27.264874
146	5	Requested	Intermediate	5	Rarely	Seeded assignment	2025-11-04 17:36:27.264874
450	21	Requested	Expert	5	\N	Seeded assignment	\N
855	10	Requested	\N	6	Rarely	Seeded assignment	\N
192	21	Requested	\N	\N	Daily	Seeded assignment	2025-11-07 21:40:27.264874
697	25	Approved	Beginner	\N	Rarely	Seeded request	\N
353	16	Approved	Advanced	2	\N	Seeded assignment	\N
28	17	Requested	\N	9	Rarely	Seeded request	2025-11-08 06:57:27.264874
422	8	Approved	\N	10	Daily	Seeded assignment	\N
327	8	Requested	\N	9	\N	Seeded assignment	\N
850	12	Approved	Beginner	0	\N	Seeded assignment	2025-11-15 11:58:27.264874
428	5	Approved	Beginner	9	Monthly	Seeded assignment	\N
758	22	Requested	Beginner	\N	Daily	Seeded assignment	2025-11-08 22:52:27.264874
905	8	Approved	Advanced	8	Daily	Seeded assignment	\N
552	21	Requested	Advanced	0	Daily	Seeded assignment	2025-11-08 12:56:27.264874
759	3	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
606	12	Requested	Expert	10	Weekly	Seeded assignment	\N
688	24	Approved	\N	1	Daily	Seeded assignment	\N
686	5	Approved	Intermediate	1	Weekly	Seeded request	2025-11-20 17:43:27.264874
847	11	Requested	\N	1	Monthly	Seeded assignment	2025-11-13 18:39:27.264874
245	8	Requested	Expert	\N	Rarely	Seeded request	\N
747	7	Requested	Advanced	8	Weekly	Seeded request	2025-12-03 01:51:27.264874
966	3	Requested	Beginner	3	Rarely	Seeded request	2025-11-27 19:22:27.264874
718	9	Approved	\N	\N	Daily	Seeded assignment	2025-11-25 17:42:27.264874
273	21	Approved	\N	9	Weekly	Seeded request	2025-11-21 13:23:27.264874
398	3	Requested	\N	\N	Weekly	Seeded assignment	2025-11-29 12:43:27.264874
311	6	Approved	Expert	\N	Monthly	Seeded request	\N
910	19	Approved	Expert	3	\N	Seeded assignment	\N
320	4	Approved	Expert	\N	Rarely	Seeded assignment	2025-11-18 22:58:27.264874
296	11	Requested	Beginner	\N	Rarely	Seeded request	\N
569	3	Requested	\N	2	\N	Seeded assignment	\N
962	6	Requested	Expert	9	Monthly	Seeded request	\N
806	22	Requested	\N	6	\N	Seeded request	\N
426	4	Approved	Expert	2	Rarely	Seeded assignment	\N
101	5	Requested	Expert	3	Weekly	Seeded assignment	\N
501	10	Approved	Beginner	2	\N	Seeded assignment	\N
841	16	Requested	Intermediate	2	Daily	Seeded assignment	\N
148	23	Approved	\N	3	Monthly	Seeded assignment	2025-11-25 04:24:27.264874
236	23	Requested	\N	\N	\N	Seeded assignment	\N
304	22	Approved	Advanced	5	\N	Seeded assignment	\N
854	23	Approved	Advanced	\N	\N	Seeded request	2025-11-14 14:08:27.264874
259	8	Approved	Advanced	\N	\N	Seeded assignment	\N
125	1	Requested	\N	8	Weekly	Seeded assignment	\N
122	21	Approved	\N	9	Daily	Seeded assignment	2025-11-15 18:09:27.264874
163	12	Requested	Intermediate	\N	\N	Seeded assignment	\N
153	1	Requested	\N	7	\N	Seeded request	2025-11-16 08:17:27.264874
341	24	Requested	Expert	\N	Daily	Seeded request	\N
895	7	Requested	Beginner	10	Monthly	Seeded assignment	\N
412	16	Requested	Expert	\N	\N	Seeded assignment	2025-11-22 06:38:27.264874
523	20	Approved	Advanced	7	\N	Seeded assignment	\N
533	12	Approved	\N	9	\N	Seeded request	\N
190	23	Requested	Beginner	\N	\N	Seeded assignment	\N
864	8	Approved	Expert	\N	\N	Seeded assignment	\N
2	18	Approved	Beginner	\N	Rarely	Seeded assignment	\N
486	13	Approved	\N	3	Weekly	Seeded assignment	\N
205	24	Approved	\N	\N	\N	Seeded request	2025-11-24 09:28:27.264874
957	19	Approved	Expert	8	\N	Seeded request	\N
242	23	Approved	Intermediate	10	Monthly	Seeded request	2025-11-28 13:08:27.264874
772	6	Approved	\N	8	\N	Seeded assignment	2025-11-29 19:07:27.264874
20	13	Requested	Advanced	\N	Weekly	Seeded assignment	\N
79	17	Approved	\N	3	Weekly	Seeded request	\N
159	10	Approved	\N	6	\N	Seeded assignment	2025-11-19 08:46:27.264874
397	13	Requested	\N	1	Daily	Seeded request	2025-11-30 13:13:27.264874
872	5	Approved	\N	\N	Rarely	Seeded assignment	\N
641	24	Requested	Beginner	9	Monthly	Seeded assignment	2025-11-08 13:38:27.264874
548	6	Approved	Beginner	10	Rarely	Seeded request	2025-11-24 09:20:27.264874
774	20	Approved	Beginner	\N	\N	Seeded assignment	\N
21	9	Requested	\N	2	Weekly	Seeded request	\N
627	4	Requested	Intermediate	9	Weekly	Seeded assignment	\N
123	22	Approved	\N	\N	Weekly	Seeded assignment	\N
186	12	Approved	\N	3	Monthly	Seeded assignment	2025-11-15 19:14:27.264874
61	8	Approved	\N	\N	\N	Seeded assignment	2025-11-27 03:39:27.264874
620	13	Approved	\N	4	Daily	Seeded assignment	\N
313	21	Approved	Expert	8	Weekly	Seeded assignment	2025-11-16 09:42:27.264874
28	21	Approved	Expert	0	Rarely	Seeded assignment	\N
165	9	Approved	\N	\N	\N	Seeded assignment	2025-11-24 07:49:27.264874
70	7	Requested	Intermediate	1	\N	Seeded request	2025-11-25 02:47:27.264874
110	21	Approved	Advanced	1	Daily	Seeded assignment	\N
81	10	Approved	Beginner	\N	Rarely	Seeded assignment	2025-11-06 23:41:27.264874
277	4	Requested	Expert	\N	\N	Seeded assignment	2025-11-23 05:09:27.264874
321	18	Approved	\N	0	Weekly	Seeded request	\N
801	5	Approved	Intermediate	5	Weekly	Seeded assignment	\N
978	7	Requested	Expert	7	Daily	Seeded request	\N
385	10	Requested	Expert	2	\N	Seeded assignment	2025-11-18 01:45:27.264874
441	10	Approved	Advanced	\N	Weekly	Seeded request	\N
568	23	Approved	Expert	\N	Rarely	Seeded assignment	\N
34	18	Requested	Expert	5	\N	Seeded assignment	\N
675	24	Approved	\N	7	Rarely	Seeded request	2025-11-21 13:31:27.264874
183	6	Approved	Advanced	7	Rarely	Seeded assignment	2025-11-05 22:53:27.264874
29	17	Approved	Expert	6	Monthly	Seeded assignment	\N
606	5	Approved	\N	\N	Daily	Seeded request	\N
669	24	Approved	Advanced	\N	Monthly	Seeded request	2025-11-21 23:53:27.264874
848	18	Approved	\N	0	\N	Seeded request	\N
752	12	Requested	Advanced	4	\N	Seeded request	\N
285	13	Requested	\N	\N	Monthly	Seeded request	\N
684	18	Approved	Intermediate	1	\N	Seeded request	2025-11-05 01:11:27.264874
420	6	Approved	\N	\N	Rarely	Seeded request	2025-11-19 09:13:27.264874
575	9	Approved	\N	\N	\N	Seeded request	2025-11-09 06:57:27.264874
633	20	Requested	Intermediate	\N	Monthly	Seeded assignment	\N
511	25	Requested	\N	8	Monthly	Seeded request	2025-11-12 02:19:27.264874
193	12	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-28 07:55:27.264874
919	4	Requested	Expert	\N	\N	Seeded request	\N
607	17	Requested	\N	\N	\N	Seeded assignment	2025-11-23 15:44:27.264874
621	10	Requested	\N	\N	\N	Seeded request	2025-11-25 21:30:27.264874
550	13	Requested	\N	4	\N	Seeded request	\N
499	3	Requested	Expert	\N	Weekly	Seeded request	\N
734	10	Requested	Intermediate	\N	\N	Seeded request	\N
387	17	Approved	\N	3	Rarely	Seeded assignment	\N
46	4	Requested	\N	\N	\N	Seeded assignment	\N
802	5	Approved	\N	7	\N	Seeded request	\N
73	4	Requested	\N	\N	\N	Seeded assignment	\N
977	9	Requested	\N	\N	Rarely	Seeded request	2025-11-03 15:34:27.264874
708	24	Requested	Intermediate	\N	Rarely	Seeded request	\N
624	11	Approved	\N	5	\N	Seeded request	2025-11-18 12:07:27.264874
754	7	Requested	Beginner	4	Weekly	Seeded assignment	2025-11-27 15:05:27.264874
250	18	Approved	Intermediate	\N	Rarely	Seeded request	\N
483	21	Requested	Intermediate	3	\N	Seeded request	2025-11-09 15:04:27.264874
812	20	Approved	\N	7	Rarely	Seeded request	2025-11-17 01:40:27.264874
350	10	Approved	\N	6	\N	Seeded assignment	\N
672	12	Requested	Expert	8	Daily	Seeded request	\N
626	11	Approved	Advanced	\N	Daily	Seeded assignment	\N
782	22	Requested	Intermediate	\N	\N	Seeded assignment	\N
95	24	Approved	Advanced	6	Weekly	Seeded assignment	\N
572	23	Requested	\N	6	\N	Seeded assignment	\N
978	23	Requested	Beginner	\N	\N	Seeded assignment	\N
650	7	Requested	Advanced	7	Weekly	Seeded assignment	\N
583	7	Requested	Advanced	\N	\N	Seeded assignment	\N
233	4	Requested	\N	9	Rarely	Seeded request	2025-11-22 04:11:27.264874
140	9	Requested	Expert	\N	Daily	Seeded assignment	\N
596	16	Approved	Expert	2	\N	Seeded request	\N
911	6	Approved	Expert	\N	\N	Seeded request	2025-11-04 05:54:27.264874
15	9	Approved	\N	6	\N	Seeded assignment	\N
13	4	Approved	\N	0	Monthly	Seeded request	2025-11-06 06:18:27.264874
204	24	Requested	\N	\N	\N	Seeded request	2025-11-05 06:58:27.264874
91	4	Approved	Advanced	9	Weekly	Seeded request	2025-11-11 20:42:27.264874
604	21	Approved	Beginner	3	\N	Seeded request	2025-11-30 10:52:27.264874
369	17	Approved	Advanced	5	Monthly	Seeded request	\N
507	16	Approved	\N	\N	\N	Seeded assignment	\N
980	12	Requested	\N	\N	\N	Seeded assignment	2025-11-17 08:00:27.264874
93	5	Requested	Expert	\N	Rarely	Seeded assignment	\N
303	1	Approved	Beginner	5	\N	Seeded request	\N
89	18	Requested	Expert	10	\N	Seeded assignment	2025-11-03 19:37:27.264874
695	22	Requested	\N	7	Daily	Seeded assignment	2025-12-02 01:05:27.264874
160	18	Approved	Expert	\N	\N	Seeded request	2025-11-16 19:48:27.264874
961	21	Approved	\N	7	Daily	Seeded request	2025-11-22 08:41:27.264874
146	20	Approved	Beginner	3	Monthly	Seeded request	\N
351	17	Requested	Beginner	0	\N	Seeded assignment	\N
972	8	Approved	Advanced	2	Daily	Seeded assignment	\N
838	13	Approved	\N	\N	Weekly	Seeded request	\N
509	25	Approved	Advanced	\N	Weekly	Seeded assignment	\N
808	8	Approved	Expert	\N	Weekly	Seeded request	2025-11-22 13:02:27.264874
785	5	Requested	\N	\N	Daily	Seeded assignment	2025-11-21 11:43:27.264874
686	20	Requested	Intermediate	8	\N	Seeded request	\N
302	17	Approved	\N	\N	\N	Seeded assignment	\N
382	13	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-10 20:43:27.264874
41	25	Requested	Beginner	2	Daily	Seeded request	2025-11-25 19:57:27.264874
331	8	Approved	\N	3	\N	Seeded request	\N
751	24	Requested	Beginner	8	Weekly	Seeded request	2025-11-23 13:02:27.264874
391	3	Approved	\N	3	\N	Seeded assignment	2025-11-28 20:08:27.264874
840	25	Requested	Beginner	1	\N	Seeded assignment	2025-11-18 04:24:27.264874
763	20	Approved	Beginner	10	Monthly	Seeded assignment	\N
831	21	Requested	Intermediate	3	\N	Seeded assignment	\N
320	3	Requested	Intermediate	10	Rarely	Seeded assignment	\N
301	1	Requested	Expert	9	Daily	Seeded assignment	\N
56	9	Requested	Expert	6	Weekly	Seeded request	2025-11-19 12:35:27.264874
472	6	Requested	\N	\N	Daily	Seeded request	\N
564	25	Approved	\N	1	Monthly	Seeded assignment	\N
17	11	Approved	Expert	3	Daily	Seeded request	\N
832	8	Approved	\N	\N	Weekly	Seeded assignment	2025-11-23 20:02:27.264874
836	19	Requested	Advanced	0	\N	Seeded request	\N
176	6	Requested	\N	2	\N	Seeded assignment	\N
404	22	Requested	\N	5	Rarely	Seeded assignment	\N
897	4	Approved	Beginner	\N	Monthly	Seeded assignment	2025-11-14 06:22:27.264874
930	24	Requested	Advanced	\N	\N	Seeded request	2025-11-24 16:03:27.264874
976	4	Approved	Expert	\N	\N	Seeded request	2025-12-01 01:38:27.264874
137	13	Approved	Intermediate	\N	Monthly	Seeded request	2025-12-01 19:48:27.264874
357	11	Approved	Expert	8	\N	Seeded assignment	\N
958	11	Approved	Beginner	0	Rarely	Seeded assignment	2025-11-25 18:57:27.264874
135	18	Approved	\N	2	\N	Seeded assignment	2025-12-01 22:44:27.264874
105	23	Approved	Advanced	6	Rarely	Seeded assignment	\N
854	7	Approved	Expert	3	\N	Seeded request	\N
499	4	Approved	Advanced	10	Monthly	Seeded request	\N
909	23	Approved	Advanced	5	Daily	Seeded request	2025-11-27 05:18:27.264874
481	25	Requested	\N	4	Monthly	Seeded request	2025-11-04 15:43:27.264874
361	3	Approved	Expert	8	\N	Seeded assignment	\N
895	23	Requested	Beginner	0	\N	Seeded request	\N
333	22	Approved	Advanced	\N	Weekly	Seeded assignment	2025-11-23 01:00:27.264874
480	9	Approved	\N	6	\N	Seeded request	2025-11-13 22:22:27.264874
342	7	Requested	Expert	\N	\N	Seeded assignment	2025-11-22 16:41:27.264874
487	21	Requested	Intermediate	2	\N	Seeded request	\N
919	3	Approved	\N	\N	\N	Seeded assignment	2025-11-20 06:19:27.264874
293	16	Approved	Beginner	5	\N	Seeded request	\N
129	24	Approved	Expert	\N	Monthly	Seeded request	\N
534	10	Approved	Advanced	3	Monthly	Seeded request	\N
16	7	Approved	Beginner	\N	Monthly	Seeded assignment	2025-11-22 09:40:27.264874
383	8	Requested	\N	6	Daily	Seeded request	\N
190	7	Approved	Beginner	\N	Rarely	Seeded request	\N
837	16	Approved	Intermediate	\N	\N	Seeded assignment	\N
839	12	Requested	Advanced	0	Weekly	Seeded request	\N
852	19	Approved	\N	6	Weekly	Seeded request	\N
332	3	Requested	\N	5	Rarely	Seeded request	2025-11-06 07:45:27.264874
242	7	Requested	Expert	4	\N	Seeded request	2025-11-24 07:33:27.264874
520	10	Approved	\N	\N	Monthly	Seeded assignment	\N
977	1	Requested	\N	10	Weekly	Seeded request	2025-11-17 08:38:27.264874
595	9	Approved	\N	8	Weekly	Seeded request	\N
556	22	Approved	\N	9	\N	Seeded request	\N
145	20	Requested	Beginner	8	Rarely	Seeded request	2025-11-26 20:21:27.264874
292	13	Requested	Expert	7	Monthly	Seeded assignment	2025-11-16 21:50:27.264874
644	11	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-05 18:50:27.264874
365	4	Approved	Expert	6	\N	Seeded assignment	\N
462	16	Approved	\N	\N	Daily	Seeded assignment	2025-11-21 14:40:27.264874
178	12	Approved	Advanced	9	Monthly	Seeded assignment	\N
515	1	Approved	\N	\N	Monthly	Seeded assignment	2025-11-27 10:38:27.264874
457	10	Approved	Beginner	3	Weekly	Seeded assignment	2025-11-21 03:31:27.264874
453	8	Requested	\N	\N	Monthly	Seeded request	\N
914	11	Requested	\N	1	\N	Seeded assignment	\N
467	7	Approved	\N	\N	\N	Seeded request	2025-11-26 05:57:27.264874
539	7	Approved	\N	\N	\N	Seeded request	\N
413	9	Approved	Intermediate	8	\N	Seeded assignment	\N
33	22	Approved	Expert	9	Monthly	Seeded assignment	\N
629	9	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
45	10	Approved	Beginner	8	Daily	Seeded assignment	2025-12-01 10:34:27.264874
195	8	Requested	\N	9	Weekly	Seeded assignment	\N
815	16	Approved	\N	5	Monthly	Seeded assignment	\N
35	21	Requested	\N	2	Rarely	Seeded assignment	\N
198	9	Approved	\N	\N	Weekly	Seeded assignment	\N
695	12	Requested	Beginner	\N	\N	Seeded request	\N
52	5	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
143	3	Approved	\N	\N	Daily	Seeded assignment	\N
721	23	Requested	\N	9	Daily	Seeded assignment	\N
707	8	Approved	\N	\N	Daily	Seeded request	2025-11-08 11:43:27.264874
366	5	Requested	Expert	1	Rarely	Seeded assignment	2025-11-11 01:28:27.264874
468	11	Approved	Advanced	1	\N	Seeded request	\N
575	11	Requested	\N	10	\N	Seeded request	\N
325	1	Approved	Beginner	1	\N	Seeded request	\N
17	1	Requested	Beginner	6	Monthly	Seeded assignment	\N
199	10	Approved	Expert	\N	Daily	Seeded assignment	2025-12-01 22:22:27.264874
787	21	Approved	Expert	\N	\N	Seeded assignment	\N
944	21	Requested	\N	5	\N	Seeded assignment	2025-11-13 16:52:27.264874
819	20	Approved	\N	\N	\N	Seeded assignment	\N
321	3	Requested	Expert	\N	\N	Seeded assignment	\N
400	20	Approved	Intermediate	7	Daily	Seeded request	\N
893	20	Requested	Intermediate	3	\N	Seeded request	\N
903	8	Requested	Intermediate	\N	\N	Seeded assignment	\N
964	23	Approved	Advanced	9	Rarely	Seeded assignment	\N
154	21	Requested	Expert	\N	Monthly	Seeded request	\N
478	9	Requested	\N	9	Rarely	Seeded assignment	\N
473	20	Approved	Beginner	10	Weekly	Seeded request	\N
316	23	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-14 08:43:27.264874
823	9	Approved	\N	\N	Daily	Seeded assignment	\N
191	4	Approved	Beginner	4	\N	Seeded request	2025-11-17 05:20:27.264874
791	17	Approved	\N	3	\N	Seeded request	2025-11-22 22:16:27.264874
816	1	Requested	Expert	4	\N	Seeded assignment	\N
960	17	Approved	\N	\N	Weekly	Seeded request	\N
417	6	Approved	\N	0	Rarely	Seeded assignment	\N
554	4	Approved	Beginner	8	Weekly	Seeded assignment	2025-11-03 06:31:27.264874
626	9	Approved	Advanced	\N	\N	Seeded request	\N
222	25	Approved	Advanced	4	Rarely	Seeded request	2025-11-21 03:57:27.264874
317	13	Requested	\N	1	Weekly	Seeded request	\N
934	23	Approved	Advanced	\N	Rarely	Seeded assignment	2025-11-27 00:13:27.264874
121	21	Approved	Beginner	\N	Rarely	Seeded assignment	2025-11-09 10:26:27.264874
327	10	Approved	Advanced	\N	\N	Seeded assignment	\N
78	19	Requested	Advanced	6	\N	Seeded assignment	2025-12-01 16:30:27.264874
297	20	Requested	\N	\N	Monthly	Seeded assignment	2025-11-19 05:00:27.264874
710	6	Requested	Intermediate	\N	\N	Seeded assignment	\N
290	17	Requested	Intermediate	\N	Weekly	Seeded request	2025-11-22 19:48:27.264874
723	11	Approved	\N	10	\N	Seeded assignment	\N
824	21	Requested	Beginner	0	\N	Seeded assignment	2025-11-24 02:03:27.264874
927	3	Approved	\N	8	Rarely	Seeded request	2025-11-04 16:50:27.264874
319	5	Approved	\N	8	Weekly	Seeded assignment	\N
528	25	Approved	\N	\N	Rarely	Seeded assignment	2025-11-11 16:44:27.264874
215	13	Requested	\N	1	Monthly	Seeded assignment	\N
499	18	Requested	Intermediate	8	Rarely	Seeded assignment	\N
394	7	Approved	Intermediate	\N	Daily	Seeded request	\N
727	20	Approved	\N	3	Monthly	Seeded request	\N
376	11	Approved	Expert	\N	\N	Seeded request	2025-11-25 10:46:27.264874
705	20	Approved	\N	\N	Rarely	Seeded assignment	\N
383	24	Requested	Advanced	7	Rarely	Seeded request	2025-11-19 21:46:27.264874
633	22	Requested	Expert	\N	\N	Seeded request	2025-11-26 14:23:27.264874
793	17	Approved	Advanced	\N	\N	Seeded assignment	2025-11-16 01:49:27.264874
333	12	Requested	Advanced	\N	\N	Seeded assignment	\N
677	10	Approved	Expert	0	\N	Seeded assignment	\N
618	17	Approved	Advanced	\N	\N	Seeded assignment	\N
553	6	Approved	Beginner	\N	Daily	Seeded request	\N
523	22	Approved	Intermediate	8	Daily	Seeded request	2025-11-12 16:19:27.264874
885	20	Requested	Intermediate	4	Daily	Seeded assignment	\N
87	21	Requested	Expert	9	Rarely	Seeded request	2025-11-15 00:16:27.264874
714	22	Approved	Intermediate	7	Weekly	Seeded request	2025-11-09 16:21:27.264874
730	18	Approved	\N	0	Daily	Seeded assignment	\N
123	20	Requested	\N	0	Weekly	Seeded request	\N
753	24	Approved	Advanced	7	Monthly	Seeded assignment	\N
95	8	Approved	\N	\N	\N	Seeded request	\N
479	16	Approved	\N	0	\N	Seeded assignment	2025-11-13 00:21:27.264874
252	1	Approved	Expert	\N	Monthly	Seeded assignment	\N
356	8	Requested	Expert	\N	Monthly	Seeded request	\N
178	22	Requested	Intermediate	3	Weekly	Seeded assignment	2025-11-10 19:09:27.264874
298	5	Approved	Intermediate	0	Weekly	Seeded request	\N
442	16	Requested	Intermediate	\N	Monthly	Seeded request	2025-11-29 14:43:27.264874
547	12	Requested	Advanced	\N	Monthly	Seeded request	\N
670	6	Approved	\N	\N	\N	Seeded assignment	\N
581	13	Approved	Beginner	\N	\N	Seeded assignment	\N
560	6	Approved	\N	4	Weekly	Seeded request	\N
454	8	Approved	\N	1	\N	Seeded assignment	\N
983	5	Approved	Intermediate	3	\N	Seeded assignment	\N
224	23	Approved	Intermediate	\N	\N	Seeded assignment	\N
489	1	Requested	\N	6	Weekly	Seeded request	\N
735	23	Approved	Beginner	7	Weekly	Seeded request	2025-11-26 16:24:27.264874
751	8	Requested	Beginner	\N	Rarely	Seeded assignment	\N
42	7	Approved	Advanced	\N	Monthly	Seeded assignment	\N
798	24	Approved	Intermediate	\N	Rarely	Seeded request	2025-11-17 12:30:27.264874
301	11	Requested	\N	1	Daily	Seeded request	2025-11-05 13:33:27.264874
870	7	Requested	Intermediate	\N	Monthly	Seeded assignment	2025-11-23 18:12:27.264874
43	21	Requested	Beginner	8	Daily	Seeded request	\N
403	19	Approved	Beginner	8	\N	Seeded assignment	\N
102	3	Approved	\N	7	\N	Seeded request	\N
304	20	Approved	\N	\N	\N	Seeded assignment	\N
226	18	Requested	Advanced	10	\N	Seeded assignment	2025-11-18 07:04:27.264874
519	13	Approved	Advanced	\N	\N	Seeded request	2025-11-16 01:26:27.264874
482	21	Approved	\N	5	Daily	Seeded assignment	\N
244	19	Requested	Advanced	4	Daily	Seeded request	\N
31	16	Requested	Advanced	6	Monthly	Seeded assignment	2025-11-04 16:20:27.264874
640	4	Requested	Advanced	\N	\N	Seeded request	\N
160	4	Approved	Intermediate	5	Rarely	Seeded request	\N
239	16	Approved	\N	9	\N	Seeded assignment	\N
352	23	Approved	Intermediate	\N	Rarely	Seeded assignment	\N
104	22	Requested	Expert	\N	\N	Seeded assignment	\N
529	7	Approved	Beginner	\N	\N	Seeded request	2025-11-07 11:09:27.264874
163	22	Approved	Expert	8	\N	Seeded assignment	2025-11-04 14:42:27.264874
96	19	Requested	Advanced	\N	Monthly	Seeded request	\N
12	16	Requested	Advanced	\N	\N	Seeded assignment	\N
39	3	Requested	\N	\N	Daily	Seeded request	2025-11-26 13:35:27.264874
7	21	Requested	\N	5	Weekly	Seeded assignment	2025-11-25 18:28:27.264874
861	9	Approved	\N	6	Daily	Seeded request	\N
103	17	Approved	Expert	\N	Daily	Seeded assignment	2025-11-20 19:01:27.264874
128	13	Requested	Advanced	7	\N	Seeded assignment	2025-11-06 00:52:27.264874
407	10	Approved	Intermediate	3	Weekly	Seeded request	\N
578	20	Requested	Beginner	\N	Weekly	Seeded assignment	2025-11-25 05:39:27.264874
945	25	Requested	Expert	3	\N	Seeded assignment	\N
514	6	Approved	Expert	10	\N	Seeded assignment	2025-11-08 05:33:27.264874
556	20	Approved	\N	\N	Monthly	Seeded assignment	2025-12-01 20:33:27.264874
956	22	Approved	\N	9	Weekly	Seeded assignment	\N
958	9	Approved	\N	0	Weekly	Seeded assignment	\N
191	3	Approved	Intermediate	\N	\N	Seeded request	\N
810	17	Requested	\N	6	\N	Seeded request	\N
586	7	Approved	Beginner	6	Rarely	Seeded request	\N
171	17	Requested	Advanced	9	Monthly	Seeded assignment	\N
59	23	Approved	Beginner	\N	Monthly	Seeded request	2025-11-16 11:28:27.264874
725	13	Approved	\N	3	Weekly	Seeded request	2025-11-15 17:40:27.264874
404	20	Requested	Advanced	\N	Weekly	Seeded request	\N
975	25	Requested	Advanced	\N	Monthly	Seeded assignment	2025-11-23 21:48:27.264874
223	21	Requested	Advanced	\N	\N	Seeded assignment	\N
502	23	Approved	\N	0	Rarely	Seeded request	2025-12-02 09:00:27.264874
34	4	Approved	\N	\N	\N	Seeded request	\N
182	18	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
735	7	Approved	\N	8	Daily	Seeded assignment	\N
949	4	Requested	\N	0	Rarely	Seeded assignment	\N
636	11	Requested	Advanced	0	\N	Seeded assignment	\N
668	25	Requested	Expert	2	Rarely	Seeded assignment	\N
139	4	Approved	\N	9	\N	Seeded request	2025-11-15 22:45:27.264874
75	25	Approved	Intermediate	\N	Daily	Seeded assignment	\N
868	18	Requested	Advanced	4	Monthly	Seeded assignment	\N
947	7	Requested	Beginner	\N	Weekly	Seeded request	\N
918	16	Approved	\N	\N	\N	Seeded request	\N
624	1	Approved	\N	\N	Weekly	Seeded assignment	2025-11-22 06:07:27.264874
965	18	Requested	Intermediate	9	Weekly	Seeded assignment	2025-11-10 09:50:27.264874
353	13	Approved	Intermediate	\N	\N	Seeded request	\N
118	21	Requested	Beginner	9	\N	Seeded assignment	\N
662	3	Approved	Expert	0	Weekly	Seeded assignment	2025-11-25 00:45:27.264874
533	22	Approved	\N	0	Monthly	Seeded assignment	\N
561	25	Approved	Intermediate	6	\N	Seeded assignment	\N
94	6	Approved	\N	2	\N	Seeded assignment	\N
699	6	Requested	Advanced	6	\N	Seeded request	2025-11-28 09:31:27.264874
800	20	Approved	\N	10	Weekly	Seeded assignment	2025-11-27 12:36:27.264874
371	10	Requested	Expert	9	Weekly	Seeded request	\N
498	19	Approved	\N	7	Rarely	Seeded request	\N
816	9	Approved	Expert	7	\N	Seeded assignment	2025-11-27 02:50:27.264874
333	20	Approved	\N	7	\N	Seeded request	2025-11-03 17:10:27.264874
640	3	Requested	Expert	0	Rarely	Seeded assignment	\N
184	5	Requested	Advanced	9	\N	Seeded request	\N
341	8	Approved	Beginner	\N	Weekly	Seeded request	\N
146	22	Approved	\N	9	\N	Seeded request	2025-11-19 19:53:27.264874
796	4	Requested	Intermediate	0	Monthly	Seeded request	\N
53	17	Requested	Beginner	\N	\N	Seeded assignment	\N
2	4	Approved	\N	\N	Weekly	Seeded assignment	\N
377	5	Requested	\N	\N	Daily	Seeded request	\N
544	25	Approved	\N	10	\N	Seeded request	\N
326	13	Requested	Intermediate	9	Rarely	Seeded request	\N
175	6	Requested	Beginner	6	\N	Seeded request	2025-11-08 02:26:27.264874
380	10	Approved	Intermediate	8	\N	Seeded assignment	2025-11-14 06:02:27.264874
259	24	Approved	\N	\N	\N	Seeded request	2025-11-29 09:37:27.264874
427	5	Approved	Advanced	\N	\N	Seeded assignment	2025-11-27 15:02:27.264874
721	7	Approved	\N	\N	Rarely	Seeded assignment	\N
297	12	Approved	\N	\N	\N	Seeded assignment	2025-12-01 14:46:27.264874
676	8	Approved	\N	\N	Monthly	Seeded assignment	2025-11-15 06:40:27.264874
10	22	Requested	Beginner	0	Weekly	Seeded assignment	\N
138	10	Approved	Expert	7	\N	Seeded request	\N
686	22	Requested	\N	8	Rarely	Seeded assignment	\N
637	5	Approved	\N	\N	Monthly	Seeded request	\N
966	19	Requested	Intermediate	9	Daily	Seeded request	\N
287	20	Requested	Intermediate	\N	Weekly	Seeded assignment	\N
463	23	Approved	Beginner	4	Daily	Seeded assignment	\N
775	19	Approved	Intermediate	\N	\N	Seeded assignment	\N
430	7	Approved	Beginner	2	Rarely	Seeded request	2025-11-15 09:05:27.264874
562	25	Approved	Advanced	10	Daily	Seeded request	2025-11-28 11:47:27.264874
172	13	Requested	Beginner	5	Daily	Seeded assignment	2025-11-24 08:11:27.264874
206	25	Requested	Beginner	\N	\N	Seeded assignment	\N
194	7	Approved	Beginner	\N	Rarely	Seeded assignment	2025-11-10 18:34:27.264874
400	12	Approved	Beginner	\N	Weekly	Seeded request	2025-11-05 13:33:27.264874
610	20	Requested	Beginner	2	Weekly	Seeded assignment	2025-11-14 21:45:27.264874
689	12	Approved	Expert	\N	Rarely	Seeded assignment	\N
893	12	Requested	\N	10	Daily	Seeded assignment	\N
654	19	Requested	\N	1	Weekly	Seeded request	2025-11-14 04:20:27.264874
736	5	Approved	\N	7	\N	Seeded assignment	\N
817	3	Requested	Beginner	\N	\N	Seeded request	\N
576	19	Requested	\N	1	Rarely	Seeded request	\N
207	23	Approved	Expert	9	Monthly	Seeded assignment	2025-11-08 17:55:27.264874
312	6	Approved	Expert	2	Monthly	Seeded request	\N
933	21	Requested	Advanced	5	Monthly	Seeded request	2025-11-11 08:32:27.264874
389	8	Approved	\N	\N	Daily	Seeded assignment	\N
674	22	Requested	\N	\N	\N	Seeded assignment	2025-11-20 03:25:27.264874
131	9	Approved	\N	\N	\N	Seeded assignment	\N
394	23	Approved	\N	1	Daily	Seeded request	2025-11-26 22:17:27.264874
853	22	Requested	Beginner	\N	Rarely	Seeded assignment	\N
843	16	Requested	Intermediate	8	\N	Seeded request	\N
107	19	Approved	\N	\N	\N	Seeded assignment	\N
679	19	Approved	\N	4	Rarely	Seeded request	\N
423	24	Approved	Expert	\N	Daily	Seeded assignment	\N
489	9	Approved	\N	2	Weekly	Seeded request	2025-11-04 14:50:27.264874
702	8	Requested	\N	6	Monthly	Seeded assignment	\N
777	4	Approved	Expert	7	Rarely	Seeded assignment	2025-11-25 10:32:27.264874
133	13	Approved	Expert	\N	\N	Seeded assignment	2025-11-23 18:06:27.264874
582	4	Requested	Advanced	3	Weekly	Seeded assignment	2025-11-04 01:04:27.264874
32	5	Requested	\N	7	\N	Seeded assignment	2025-11-06 14:28:27.264874
279	13	Requested	Intermediate	0	Monthly	Seeded assignment	2025-11-20 01:47:27.264874
197	8	Requested	Intermediate	\N	Monthly	Seeded request	2025-11-11 11:04:27.264874
234	16	Approved	Advanced	5	\N	Seeded request	\N
737	20	Approved	Expert	7	Weekly	Seeded assignment	\N
323	10	Approved	Beginner	\N	\N	Seeded request	\N
813	12	Requested	Intermediate	2	Rarely	Seeded assignment	2025-11-13 15:38:27.264874
678	10	Approved	Intermediate	10	\N	Seeded assignment	2025-11-08 15:10:27.264874
779	3	Requested	Expert	\N	Rarely	Seeded request	2025-11-24 22:27:27.264874
370	23	Requested	Intermediate	6	\N	Seeded assignment	\N
671	24	Approved	\N	\N	Daily	Seeded request	\N
631	13	Approved	\N	\N	Monthly	Seeded request	\N
270	22	Approved	\N	\N	Monthly	Seeded assignment	\N
244	18	Approved	\N	6	Monthly	Seeded assignment	2025-12-02 17:20:27.264874
226	19	Approved	\N	6	Rarely	Seeded request	\N
580	6	Approved	Intermediate	3	\N	Seeded assignment	2025-11-17 07:02:27.264874
687	13	Requested	Beginner	7	Monthly	Seeded assignment	\N
265	3	Approved	Expert	6	Rarely	Seeded request	2025-11-08 22:51:27.264874
91	19	Approved	Intermediate	10	Rarely	Seeded request	2025-11-26 08:19:27.264874
253	22	Approved	Intermediate	4	\N	Seeded assignment	\N
13	19	Requested	Intermediate	3	Rarely	Seeded request	2025-11-14 21:07:27.264874
151	22	Approved	Beginner	1	Daily	Seeded assignment	\N
564	6	Requested	Beginner	\N	Monthly	Seeded request	\N
693	23	Requested	Beginner	10	Daily	Seeded request	\N
509	6	Approved	\N	5	\N	Seeded assignment	\N
485	19	Approved	Expert	\N	Daily	Seeded assignment	2025-11-04 20:50:27.264874
83	13	Approved	Intermediate	5	Rarely	Seeded request	\N
946	5	Requested	Expert	2	Daily	Seeded request	\N
112	20	Approved	Intermediate	4	Daily	Seeded request	2025-11-22 02:25:27.264874
147	25	Approved	Intermediate	2	\N	Seeded assignment	2025-12-03 04:16:27.264874
260	17	Requested	Intermediate	\N	Daily	Seeded request	2025-11-22 09:53:27.264874
579	5	Approved	Beginner	\N	\N	Seeded assignment	\N
534	8	Requested	\N	6	\N	Seeded assignment	2025-11-23 06:03:27.264874
497	16	Requested	\N	7	Daily	Seeded assignment	\N
541	9	Approved	\N	\N	\N	Seeded request	\N
569	19	Requested	Expert	\N	Monthly	Seeded request	\N
603	11	Approved	Expert	9	\N	Seeded assignment	\N
688	8	Requested	Beginner	\N	Weekly	Seeded assignment	2025-11-13 17:22:27.264874
120	4	Requested	Intermediate	8	\N	Seeded assignment	2025-12-02 13:36:27.264874
730	19	Requested	Expert	2	Rarely	Seeded assignment	\N
857	21	Approved	Expert	3	Weekly	Seeded assignment	2025-11-14 09:08:27.264874
307	9	Requested	\N	0	Rarely	Seeded assignment	2025-11-09 14:36:27.264874
550	16	Requested	Beginner	2	\N	Seeded request	2025-11-05 05:08:27.264874
970	5	Approved	Beginner	2	Daily	Seeded request	\N
379	3	Requested	\N	1	Rarely	Seeded request	\N
422	24	Requested	\N	5	Monthly	Seeded assignment	\N
453	10	Approved	Beginner	9	\N	Seeded assignment	2025-11-29 02:27:27.264874
692	11	Requested	\N	1	\N	Seeded assignment	\N
933	17	Approved	Expert	\N	Weekly	Seeded request	2025-11-04 01:26:27.264874
803	11	Requested	\N	\N	\N	Seeded assignment	\N
268	4	Approved	\N	\N	\N	Seeded assignment	2025-11-12 12:43:27.264874
765	3	Approved	\N	\N	Rarely	Seeded assignment	\N
328	17	Approved	Expert	\N	\N	Seeded request	\N
525	21	Requested	Beginner	0	\N	Seeded request	\N
794	6	Requested	\N	\N	Monthly	Seeded assignment	\N
461	19	Approved	Intermediate	\N	Monthly	Seeded assignment	2025-11-26 09:05:27.264874
499	19	Requested	\N	10	Rarely	Seeded assignment	\N
753	10	Approved	Advanced	\N	Daily	Seeded request	\N
264	1	Approved	\N	\N	Daily	Seeded assignment	2025-11-09 08:58:27.264874
810	21	Approved	Intermediate	8	Rarely	Seeded request	2025-12-02 01:29:27.264874
366	20	Requested	Beginner	2	Daily	Seeded assignment	2025-11-12 12:29:27.264874
939	23	Approved	\N	0	\N	Seeded request	2025-11-10 13:17:27.264874
263	17	Approved	Beginner	8	\N	Seeded assignment	\N
78	18	Approved	Expert	\N	Rarely	Seeded request	\N
1	24	Approved	Expert	\N	Weekly	Seeded assignment	2025-11-18 14:10:27.264874
589	20	Requested	Expert	\N	\N	Seeded assignment	2025-11-29 18:07:27.264874
802	22	Requested	Advanced	\N	Monthly	Seeded request	\N
238	3	Approved	Expert	10	Monthly	Seeded assignment	2025-11-06 15:52:27.264874
180	23	Approved	\N	1	Rarely	Seeded assignment	\N
164	18	Approved	Advanced	0	Monthly	Seeded assignment	2025-11-26 18:40:27.264874
7	17	Approved	Beginner	5	Monthly	Seeded request	2025-11-25 07:19:27.264874
704	18	Approved	Expert	6	Rarely	Seeded assignment	\N
871	23	Approved	Advanced	\N	Weekly	Seeded assignment	2025-11-13 12:29:27.264874
836	4	Approved	Expert	\N	Daily	Seeded assignment	\N
329	23	Approved	Beginner	1	Weekly	Seeded assignment	\N
346	13	Approved	Intermediate	1	Daily	Seeded request	\N
893	5	Approved	Expert	1	Rarely	Seeded assignment	2025-11-25 09:37:27.264874
858	21	Approved	\N	4	\N	Seeded request	2025-11-15 18:54:27.264874
912	24	Requested	\N	\N	\N	Seeded assignment	\N
972	10	Approved	Intermediate	6	Weekly	Seeded request	2025-11-05 21:11:27.264874
715	6	Approved	Advanced	3	Rarely	Seeded assignment	\N
22	24	Approved	\N	9	Rarely	Seeded assignment	\N
875	12	Approved	\N	9	Rarely	Seeded request	2025-11-24 02:47:27.264874
297	5	Approved	\N	0	Rarely	Seeded request	2025-11-12 09:09:27.264874
490	10	Approved	Expert	10	Monthly	Seeded assignment	\N
808	10	Approved	Advanced	2	\N	Seeded assignment	2025-11-08 14:55:27.264874
416	12	Approved	\N	\N	Monthly	Seeded request	\N
532	19	Approved	\N	\N	Weekly	Seeded assignment	\N
435	20	Requested	\N	\N	\N	Seeded request	\N
781	5	Requested	Intermediate	8	Monthly	Seeded assignment	2025-11-04 15:53:27.264874
227	21	Requested	\N	2	\N	Seeded assignment	\N
266	11	Requested	Expert	\N	\N	Seeded assignment	\N
460	8	Approved	Intermediate	6	Weekly	Seeded assignment	\N
319	20	Approved	Beginner	4	\N	Seeded request	\N
272	17	Approved	Beginner	\N	Monthly	Seeded request	\N
427	12	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-07 02:44:27.264874
600	20	Approved	Advanced	\N	\N	Seeded assignment	\N
904	21	Approved	Advanced	\N	Daily	Seeded request	2025-11-27 03:15:27.264874
223	17	Approved	\N	\N	Weekly	Seeded request	\N
411	10	Requested	Expert	\N	Monthly	Seeded assignment	2025-12-02 08:40:27.264874
439	7	Approved	Intermediate	6	Monthly	Seeded request	\N
521	6	Approved	\N	0	\N	Seeded assignment	2025-11-05 18:20:27.264874
231	17	Approved	\N	\N	\N	Seeded assignment	\N
158	18	Requested	\N	\N	Monthly	Seeded assignment	2025-11-07 13:55:27.264874
733	3	Requested	Intermediate	0	Rarely	Seeded assignment	\N
682	24	Requested	Expert	10	Monthly	Seeded assignment	\N
388	25	Requested	Beginner	4	\N	Seeded assignment	\N
455	22	Approved	Expert	3	\N	Seeded assignment	\N
274	13	Requested	\N	\N	Daily	Seeded request	\N
557	8	Requested	Beginner	9	Rarely	Seeded assignment	2025-11-26 20:48:27.264874
349	23	Approved	Beginner	\N	\N	Seeded assignment	2025-11-15 08:46:27.264874
184	20	Approved	\N	3	Daily	Seeded request	\N
441	8	Approved	Expert	1	\N	Seeded request	2025-11-21 06:16:27.264874
543	13	Approved	\N	\N	Weekly	Seeded request	\N
645	17	Approved	\N	6	Monthly	Seeded request	2025-11-14 16:41:27.264874
107	18	Approved	Beginner	3	\N	Seeded assignment	2025-11-16 01:23:27.264874
293	13	Requested	\N	\N	\N	Seeded request	2025-11-09 10:36:27.264874
973	6	Requested	Advanced	3	Daily	Seeded request	2025-11-16 06:39:27.264874
180	7	Approved	\N	\N	Weekly	Seeded request	\N
230	22	Approved	\N	7	Rarely	Seeded assignment	\N
745	16	Requested	\N	\N	Monthly	Seeded assignment	\N
435	12	Requested	\N	\N	Weekly	Seeded request	\N
667	1	Requested	\N	1	\N	Seeded assignment	2025-11-23 23:17:27.264874
391	19	Approved	Beginner	9	\N	Seeded request	\N
416	20	Approved	Advanced	\N	\N	Seeded assignment	2025-11-05 09:51:27.264874
758	20	Approved	\N	\N	Weekly	Seeded assignment	\N
414	1	Approved	\N	2	\N	Seeded assignment	\N
654	18	Requested	Expert	\N	\N	Seeded request	2025-11-20 13:33:27.264874
772	25	Approved	\N	5	Monthly	Seeded request	2025-11-04 07:18:27.264874
822	11	Approved	Intermediate	0	\N	Seeded request	2025-11-22 16:10:27.264874
137	16	Requested	\N	5	Daily	Seeded request	\N
871	7	Requested	Advanced	4	\N	Seeded assignment	2025-12-01 15:38:27.264874
637	20	Requested	Advanced	\N	\N	Seeded request	\N
610	5	Requested	Advanced	0	\N	Seeded assignment	\N
621	8	Approved	Advanced	1	\N	Seeded assignment	\N
726	24	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-16 15:02:27.264874
782	5	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-29 16:01:27.264874
789	13	Requested	Advanced	\N	Daily	Seeded assignment	\N
371	24	Approved	\N	8	\N	Seeded assignment	\N
292	16	Approved	Expert	8	Monthly	Seeded request	\N
719	13	Requested	Expert	7	\N	Seeded assignment	\N
627	19	Requested	Intermediate	10	\N	Seeded request	\N
913	12	Approved	Expert	0	\N	Seeded assignment	2025-11-30 10:06:27.264874
157	10	Approved	Expert	10	Monthly	Seeded request	2025-11-23 21:05:27.264874
149	1	Approved	Advanced	4	Weekly	Seeded request	\N
849	6	Requested	\N	6	\N	Seeded assignment	\N
863	11	Approved	Expert	\N	Daily	Seeded request	2025-11-18 06:26:27.264874
275	24	Requested	\N	4	Daily	Seeded request	2025-11-16 13:21:27.264874
967	7	Approved	\N	\N	Rarely	Seeded request	2025-11-10 06:28:27.264874
953	25	Approved	\N	1	Weekly	Seeded request	\N
837	13	Requested	\N	7	\N	Seeded request	\N
957	4	Requested	Expert	5	\N	Seeded request	\N
541	1	Approved	\N	1	\N	Seeded request	2025-11-20 22:15:27.264874
695	5	Approved	Intermediate	5	Monthly	Seeded request	\N
144	25	Approved	Advanced	2	Monthly	Seeded assignment	2025-11-29 09:58:27.264874
963	25	Approved	\N	7	\N	Seeded assignment	\N
216	20	Requested	\N	1	Monthly	Seeded assignment	\N
693	7	Requested	Advanced	7	\N	Seeded request	2025-11-28 15:24:27.264874
965	19	Approved	\N	2	\N	Seeded assignment	\N
213	22	Approved	Advanced	4	\N	Seeded assignment	2025-11-10 09:36:27.264874
347	24	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-04 13:17:27.264874
983	12	Approved	\N	1	Rarely	Seeded request	\N
573	10	Requested	\N	0	Weekly	Seeded request	2025-11-10 19:52:27.264874
355	19	Approved	\N	10	\N	Seeded request	2025-11-18 03:49:27.264874
298	12	Requested	\N	4	Weekly	Seeded assignment	2025-11-27 02:44:27.264874
942	16	Requested	\N	\N	Weekly	Seeded assignment	\N
877	7	Requested	Advanced	3	\N	Seeded assignment	\N
402	24	Requested	Expert	1	Daily	Seeded request	\N
392	18	Approved	Expert	1	Rarely	Seeded assignment	2025-11-22 22:44:27.264874
836	3	Approved	\N	0	\N	Seeded assignment	\N
290	21	Approved	\N	\N	Rarely	Seeded request	2025-11-21 05:43:27.264874
824	17	Approved	Expert	\N	Weekly	Seeded assignment	\N
950	23	Approved	\N	10	Daily	Seeded request	\N
323	24	Requested	Beginner	\N	Weekly	Seeded assignment	\N
373	22	Approved	\N	\N	Monthly	Seeded assignment	\N
159	8	Approved	\N	0	Monthly	Seeded request	\N
238	4	Approved	Intermediate	4	\N	Seeded assignment	\N
456	20	Requested	\N	\N	Rarely	Seeded assignment	\N
420	25	Approved	\N	\N	Rarely	Seeded request	\N
46	19	Requested	Expert	10	\N	Seeded assignment	2025-11-23 05:26:27.264874
902	17	Approved	\N	7	Daily	Seeded assignment	\N
791	21	Approved	Intermediate	4	Weekly	Seeded assignment	\N
901	10	Approved	Advanced	0	Weekly	Seeded assignment	2025-11-21 12:46:27.264874
196	1	Approved	Advanced	2	Monthly	Seeded assignment	2025-11-11 07:49:27.264874
333	5	Approved	Advanced	3	Rarely	Seeded request	\N
268	3	Approved	\N	\N	\N	Seeded assignment	2025-12-03 02:59:27.264874
549	3	Requested	Expert	4	Daily	Seeded assignment	2025-11-11 00:27:27.264874
121	17	Requested	Intermediate	3	Weekly	Seeded request	\N
152	6	Approved	\N	9	\N	Seeded assignment	\N
480	8	Approved	Expert	3	Daily	Seeded request	2025-12-01 09:05:27.264874
203	5	Requested	Advanced	5	Rarely	Seeded request	\N
738	21	Approved	Intermediate	\N	Monthly	Seeded request	\N
475	6	Approved	Expert	9	Rarely	Seeded assignment	\N
719	6	Requested	Beginner	3	Monthly	Seeded assignment	2025-11-27 07:23:27.264874
168	17	Approved	\N	3	\N	Seeded assignment	\N
462	6	Requested	Advanced	\N	Daily	Seeded request	\N
783	3	Requested	Intermediate	0	\N	Seeded request	2025-11-29 09:16:27.264874
5	6	Approved	Beginner	5	\N	Seeded assignment	\N
51	5	Requested	\N	7	Daily	Seeded request	2025-11-18 09:41:27.264874
449	10	Requested	Expert	6	Daily	Seeded assignment	2025-11-28 09:03:27.264874
709	11	Requested	Intermediate	\N	\N	Seeded request	\N
314	8	Approved	\N	\N	Daily	Seeded request	\N
166	16	Approved	Advanced	9	Monthly	Seeded assignment	\N
597	4	Approved	\N	\N	Rarely	Seeded assignment	\N
717	12	Requested	Expert	\N	Monthly	Seeded request	2025-11-13 17:08:27.264874
832	9	Approved	Expert	7	\N	Seeded request	\N
764	13	Approved	\N	\N	Weekly	Seeded assignment	\N
431	16	Approved	\N	3	Weekly	Seeded request	\N
50	5	Requested	Advanced	1	Daily	Seeded assignment	2025-11-21 12:10:27.264874
453	9	Approved	Expert	5	\N	Seeded assignment	\N
823	24	Approved	Advanced	9	Daily	Seeded request	\N
551	20	Approved	Expert	\N	\N	Seeded assignment	\N
179	20	Requested	Advanced	10	\N	Seeded assignment	\N
518	25	Approved	\N	\N	Daily	Seeded request	\N
66	21	Approved	Advanced	2	Monthly	Seeded request	\N
43	4	Approved	Expert	3	Monthly	Seeded request	2025-11-17 19:51:27.264874
626	24	Approved	Expert	7	\N	Seeded request	\N
616	9	Approved	\N	\N	Rarely	Seeded assignment	2025-11-15 01:34:27.264874
224	5	Approved	Beginner	5	Weekly	Seeded assignment	\N
869	6	Approved	\N	5	\N	Seeded assignment	\N
157	1	Approved	\N	\N	Monthly	Seeded assignment	2025-11-19 16:04:27.264874
624	24	Requested	Advanced	\N	Weekly	Seeded assignment	\N
388	16	Approved	Intermediate	8	\N	Seeded assignment	\N
20	25	Requested	Beginner	6	\N	Seeded assignment	2025-12-01 16:18:27.264874
367	23	Requested	Intermediate	0	\N	Seeded assignment	2025-11-22 11:23:27.264874
363	11	Approved	Expert	3	\N	Seeded request	\N
588	24	Requested	\N	\N	Weekly	Seeded request	2025-11-03 10:41:27.264874
447	12	Requested	\N	1	Rarely	Seeded assignment	2025-11-05 12:00:27.264874
770	6	Approved	\N	10	Weekly	Seeded assignment	\N
176	16	Requested	\N	7	\N	Seeded request	\N
265	17	Approved	Advanced	\N	Monthly	Seeded request	2025-11-24 09:05:27.264874
352	5	Requested	Beginner	10	\N	Seeded request	\N
973	13	Approved	Advanced	5	Rarely	Seeded assignment	\N
308	3	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-03 21:25:27.264874
154	4	Requested	\N	\N	Monthly	Seeded assignment	\N
377	7	Requested	\N	\N	Daily	Seeded assignment	\N
272	3	Approved	Expert	3	Daily	Seeded assignment	2025-11-05 21:13:27.264874
866	25	Requested	\N	10	Daily	Seeded request	2025-11-15 06:46:27.264874
944	4	Approved	Advanced	\N	\N	Seeded request	\N
787	4	Approved	\N	\N	Daily	Seeded assignment	\N
366	23	Requested	\N	\N	Rarely	Seeded assignment	\N
647	25	Approved	Beginner	4	\N	Seeded request	\N
132	5	Approved	Beginner	\N	\N	Seeded request	2025-11-27 19:49:27.264874
77	8	Requested	\N	\N	Monthly	Seeded assignment	\N
259	1	Requested	Expert	6	\N	Seeded assignment	\N
35	4	Requested	\N	\N	\N	Seeded assignment	\N
747	22	Approved	Advanced	\N	\N	Seeded assignment	2025-11-13 05:27:27.264874
147	16	Approved	\N	4	Monthly	Seeded assignment	2025-11-28 17:50:27.264874
555	17	Approved	Expert	3	Rarely	Seeded request	\N
329	20	Requested	Intermediate	2	Monthly	Seeded assignment	\N
875	7	Requested	Intermediate	3	\N	Seeded assignment	\N
964	5	Approved	Advanced	9	Weekly	Seeded request	2025-11-07 23:49:27.264874
602	4	Requested	\N	10	Rarely	Seeded assignment	2025-11-21 16:18:27.264874
445	9	Approved	\N	\N	\N	Seeded request	2025-11-28 13:54:27.264874
9	9	Approved	Expert	\N	\N	Seeded assignment	\N
278	7	Approved	Intermediate	4	\N	Seeded assignment	\N
767	11	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-26 21:56:27.264874
864	1	Requested	Advanced	\N	\N	Seeded request	\N
299	20	Approved	Advanced	7	Monthly	Seeded request	\N
430	5	Approved	Expert	10	\N	Seeded assignment	\N
934	5	Requested	\N	7	\N	Seeded request	\N
161	16	Approved	\N	6	Daily	Seeded assignment	\N
136	10	Requested	Advanced	7	Rarely	Seeded assignment	2025-11-14 02:06:27.264874
874	9	Approved	Beginner	\N	\N	Seeded request	\N
691	11	Requested	Expert	7	Rarely	Seeded assignment	2025-11-14 17:33:27.264874
228	21	Approved	Expert	\N	Weekly	Seeded assignment	2025-11-13 00:17:27.264874
291	1	Requested	Advanced	8	Rarely	Seeded request	\N
435	23	Approved	Intermediate	8	\N	Seeded request	2025-11-28 07:08:27.264874
808	9	Approved	Expert	4	Monthly	Seeded assignment	\N
901	1	Approved	Expert	6	\N	Seeded request	\N
607	19	Approved	\N	7	\N	Seeded request	\N
967	20	Requested	\N	\N	Monthly	Seeded request	2025-11-23 14:22:27.264874
732	20	Requested	\N	\N	\N	Seeded assignment	2025-11-22 13:05:27.264874
657	16	Requested	Advanced	4	\N	Seeded assignment	\N
114	11	Approved	Advanced	\N	\N	Seeded assignment	\N
550	25	Approved	\N	\N	\N	Seeded assignment	2025-11-29 16:27:27.264874
702	11	Requested	Expert	8	Rarely	Seeded request	\N
873	4	Requested	Intermediate	9	Monthly	Seeded request	\N
28	18	Requested	\N	8	\N	Seeded assignment	2025-11-20 10:25:27.264874
309	20	Approved	\N	\N	Monthly	Seeded request	\N
308	4	Approved	\N	\N	Daily	Seeded request	2025-12-01 15:00:27.264874
377	23	Approved	Beginner	8	Monthly	Seeded request	\N
592	16	Approved	\N	\N	\N	Seeded request	\N
369	19	Approved	Expert	2	\N	Seeded assignment	\N
24	23	Approved	Expert	2	Rarely	Seeded assignment	2025-11-07 11:05:27.264874
349	20	Approved	Intermediate	7	\N	Seeded assignment	2025-11-20 13:59:27.264874
821	12	Approved	\N	6	Rarely	Seeded request	2025-11-03 20:46:27.264874
306	16	Approved	Advanced	10	Rarely	Seeded request	2025-11-27 05:09:27.264874
43	3	Requested	Beginner	2	Rarely	Seeded request	2025-11-12 15:27:27.264874
585	18	Approved	Intermediate	3	Daily	Seeded request	2025-11-27 11:40:27.264874
665	17	Approved	\N	2	Daily	Seeded request	2025-11-28 15:51:27.264874
942	25	Approved	Intermediate	\N	Rarely	Seeded request	\N
958	24	Requested	\N	\N	Daily	Seeded request	\N
241	24	Approved	\N	0	Daily	Seeded assignment	2025-11-23 14:06:27.264874
357	24	Approved	Intermediate	0	\N	Seeded assignment	2025-11-24 07:04:27.264874
637	23	Requested	Intermediate	\N	\N	Seeded request	\N
491	16	Approved	Intermediate	5	Daily	Seeded assignment	\N
531	18	Requested	Intermediate	10	\N	Seeded assignment	\N
644	24	Approved	\N	4	Weekly	Seeded assignment	\N
564	13	Requested	\N	7	\N	Seeded request	\N
188	4	Approved	Advanced	\N	\N	Seeded request	2025-12-01 09:44:27.264874
418	5	Approved	\N	5	Rarely	Seeded assignment	2025-11-12 16:59:27.264874
503	9	Approved	Beginner	6	Daily	Seeded request	2025-11-28 23:48:27.264874
952	8	Approved	\N	1	\N	Seeded assignment	\N
278	23	Approved	Intermediate	\N	Daily	Seeded assignment	\N
687	6	Requested	Intermediate	10	\N	Seeded request	\N
923	8	Requested	Advanced	\N	\N	Seeded request	2025-11-20 22:37:27.264874
420	16	Approved	Intermediate	1	Daily	Seeded request	2025-11-17 22:30:27.264874
438	20	Requested	\N	7	Monthly	Seeded assignment	\N
87	3	Approved	Expert	\N	Weekly	Seeded assignment	\N
524	24	Approved	Advanced	5	\N	Seeded assignment	2025-11-28 02:32:27.264874
664	17	Approved	Advanced	6	Weekly	Seeded request	\N
41	13	Requested	\N	5	Monthly	Seeded assignment	\N
345	16	Requested	\N	4	\N	Seeded assignment	\N
382	25	Approved	\N	\N	\N	Seeded request	\N
109	24	Requested	\N	2	Monthly	Seeded request	2025-12-01 02:36:27.264874
183	16	Approved	\N	2	\N	Seeded assignment	\N
600	7	Requested	Beginner	4	Monthly	Seeded assignment	\N
711	16	Approved	\N	\N	Daily	Seeded assignment	2025-11-09 03:13:27.264874
773	4	Requested	Intermediate	4	\N	Seeded assignment	\N
127	12	Approved	Expert	10	\N	Seeded request	2025-11-09 23:16:27.264874
248	5	Approved	Expert	\N	\N	Seeded assignment	\N
954	7	Requested	Intermediate	2	\N	Seeded request	\N
85	23	Requested	Expert	0	Rarely	Seeded request	\N
6	13	Requested	Expert	\N	Monthly	Seeded request	2025-11-04 18:58:27.264874
250	21	Approved	\N	7	\N	Seeded assignment	2025-11-30 03:20:27.264874
744	12	Requested	Advanced	6	\N	Seeded assignment	\N
8	18	Requested	Advanced	\N	\N	Seeded request	2025-11-28 21:09:27.264874
749	16	Approved	\N	7	Monthly	Seeded request	\N
204	11	Requested	\N	\N	Daily	Seeded request	\N
251	10	Requested	Advanced	0	\N	Seeded assignment	\N
310	17	Requested	\N	\N	\N	Seeded request	2025-11-09 01:43:27.264874
121	3	Requested	Expert	2	Daily	Seeded request	\N
328	4	Approved	\N	4	Weekly	Seeded request	2025-11-05 10:11:27.264874
634	3	Approved	\N	\N	\N	Seeded assignment	\N
268	17	Approved	Beginner	5	Daily	Seeded assignment	\N
809	18	Requested	Expert	8	\N	Seeded assignment	\N
303	8	Approved	\N	\N	Rarely	Seeded request	\N
594	21	Requested	\N	2	\N	Seeded request	\N
867	22	Approved	Beginner	\N	\N	Seeded assignment	\N
283	16	Requested	Expert	10	Monthly	Seeded request	\N
466	21	Requested	\N	1	\N	Seeded assignment	\N
881	18	Requested	Expert	4	\N	Seeded request	\N
130	16	Requested	Expert	\N	\N	Seeded request	2025-11-23 07:22:27.264874
950	20	Approved	Advanced	9	Weekly	Seeded request	\N
828	11	Approved	Advanced	2	\N	Seeded assignment	2025-11-13 10:15:27.264874
972	1	Approved	Advanced	7	\N	Seeded assignment	\N
496	10	Approved	Expert	\N	\N	Seeded assignment	2025-11-21 17:00:27.264874
877	12	Approved	Beginner	5	Weekly	Seeded request	\N
490	1	Approved	Beginner	6	\N	Seeded assignment	2025-11-06 19:43:27.264874
292	25	Approved	\N	8	Rarely	Seeded request	2025-11-08 18:11:27.264874
459	6	Approved	Beginner	2	Daily	Seeded assignment	2025-11-26 17:53:27.264874
983	7	Requested	\N	6	Daily	Seeded assignment	\N
61	9	Requested	Beginner	5	\N	Seeded request	\N
807	17	Approved	Expert	2	Rarely	Seeded assignment	\N
693	12	Requested	Advanced	3	\N	Seeded request	\N
346	6	Requested	Beginner	\N	Rarely	Seeded assignment	\N
570	8	Approved	Advanced	6	Weekly	Seeded request	\N
231	4	Approved	\N	1	Weekly	Seeded assignment	2025-11-03 20:51:27.264874
943	22	Requested	\N	5	Weekly	Seeded request	\N
615	16	Approved	Advanced	6	\N	Seeded request	\N
826	19	Approved	\N	4	Daily	Seeded request	\N
445	1	Approved	Expert	8	Daily	Seeded assignment	2025-11-12 19:45:27.264874
321	21	Requested	Beginner	6	Daily	Seeded assignment	2025-11-12 18:30:27.264874
953	16	Approved	Beginner	9	Monthly	Seeded request	2025-11-11 17:10:27.264874
740	16	Requested	\N	8	Daily	Seeded assignment	\N
110	18	Approved	Advanced	\N	\N	Seeded request	\N
154	3	Approved	Advanced	6	\N	Seeded assignment	\N
599	10	Requested	Expert	1	Daily	Seeded assignment	2025-11-23 08:13:27.264874
537	24	Requested	Expert	9	\N	Seeded request	\N
962	16	Requested	Advanced	\N	Daily	Seeded assignment	2025-11-25 13:16:27.264874
813	23	Requested	Expert	\N	Weekly	Seeded request	2025-11-26 02:18:27.264874
927	17	Requested	Beginner	\N	\N	Seeded assignment	\N
103	4	Approved	\N	8	Rarely	Seeded request	2025-11-05 05:03:27.264874
899	24	Approved	Intermediate	7	Rarely	Seeded assignment	2025-12-02 19:23:27.264874
646	6	Approved	\N	6	Weekly	Seeded request	2025-11-29 16:40:27.264874
385	11	Approved	\N	\N	Weekly	Seeded assignment	2025-11-20 01:21:27.264874
162	13	Approved	\N	7	Weekly	Seeded assignment	\N
466	17	Requested	Beginner	\N	Weekly	Seeded assignment	\N
4	22	Requested	Intermediate	7	Monthly	Seeded assignment	2025-11-12 18:51:27.264874
458	10	Approved	\N	3	\N	Seeded request	2025-12-02 23:38:27.264874
407	1	Requested	Expert	3	Weekly	Seeded assignment	2025-11-17 10:19:27.264874
353	6	Approved	Intermediate	7	Rarely	Seeded request	\N
822	8	Requested	\N	\N	Daily	Seeded request	2025-11-29 05:15:27.264874
199	9	Approved	\N	\N	Rarely	Seeded request	\N
479	25	Approved	Intermediate	\N	Rarely	Seeded assignment	2025-11-22 02:37:27.264874
413	10	Approved	\N	8	Rarely	Seeded request	2025-11-08 19:23:27.264874
871	5	Approved	\N	2	Rarely	Seeded request	\N
629	10	Approved	\N	0	Rarely	Seeded assignment	2025-11-15 11:32:27.264874
964	20	Approved	\N	3	Weekly	Seeded request	\N
329	5	Requested	Intermediate	\N	Daily	Seeded assignment	\N
525	4	Approved	\N	\N	Rarely	Seeded assignment	\N
198	10	Requested	Intermediate	\N	Rarely	Seeded assignment	\N
316	20	Approved	Advanced	9	Rarely	Seeded request	2025-12-01 12:37:27.264874
929	3	Requested	Advanced	9	Weekly	Seeded assignment	\N
487	19	Approved	Expert	0	\N	Seeded assignment	\N
463	12	Requested	\N	2	\N	Seeded assignment	\N
568	22	Requested	\N	\N	Rarely	Seeded assignment	\N
949	17	Approved	Expert	9	\N	Seeded assignment	2025-11-13 05:13:27.264874
734	11	Approved	Advanced	\N	\N	Seeded assignment	\N
905	9	Approved	Advanced	10	Weekly	Seeded request	\N
185	19	Requested	Advanced	\N	Rarely	Seeded assignment	\N
249	20	Approved	Advanced	\N	Weekly	Seeded assignment	\N
588	10	Approved	Intermediate	\N	Daily	Seeded request	2025-11-10 23:48:27.264874
680	16	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-23 16:00:27.264874
116	11	Requested	Beginner	\N	Monthly	Seeded request	2025-11-21 01:01:27.264874
327	9	Requested	Intermediate	6	Rarely	Seeded assignment	\N
422	9	Approved	\N	\N	\N	Seeded request	2025-11-09 15:45:27.264874
684	17	Approved	\N	\N	Daily	Seeded request	2025-11-25 10:54:27.264874
149	24	Approved	Advanced	\N	Monthly	Seeded assignment	\N
886	23	Approved	\N	10	\N	Seeded request	2025-11-15 00:47:27.264874
62	13	Requested	\N	3	Monthly	Seeded assignment	\N
208	16	Requested	Expert	\N	Daily	Seeded assignment	2025-11-24 04:33:27.264874
830	18	Approved	Advanced	2	Monthly	Seeded assignment	\N
694	8	Requested	\N	1	Rarely	Seeded assignment	\N
695	7	Requested	Intermediate	8	\N	Seeded request	\N
337	23	Approved	Intermediate	\N	\N	Seeded request	2025-11-11 21:32:27.264874
805	25	Approved	Intermediate	\N	\N	Seeded request	\N
102	17	Approved	Expert	4	\N	Seeded request	2025-11-23 22:21:27.264874
370	5	Approved	\N	\N	Daily	Seeded assignment	\N
529	20	Approved	\N	10	Weekly	Seeded assignment	2025-11-27 20:43:27.264874
796	17	Requested	Expert	3	\N	Seeded request	2025-11-28 09:21:27.264874
870	12	Requested	Intermediate	\N	Monthly	Seeded assignment	2025-11-08 10:55:27.264874
885	23	Approved	\N	1	Daily	Seeded assignment	\N
380	1	Approved	Intermediate	1	Weekly	Seeded request	\N
517	22	Requested	\N	5	\N	Seeded assignment	\N
26	24	Requested	\N	\N	Weekly	Seeded request	2025-11-04 23:44:27.264874
833	25	Approved	\N	2	\N	Seeded request	2025-11-16 20:49:27.264874
296	10	Requested	Intermediate	5	\N	Seeded request	2025-11-07 13:28:27.264874
946	23	Approved	Intermediate	4	Weekly	Seeded assignment	\N
359	24	Approved	\N	7	Weekly	Seeded assignment	\N
959	5	Approved	Intermediate	0	Rarely	Seeded assignment	\N
279	6	Approved	\N	1	Rarely	Seeded request	2025-11-13 00:03:27.264874
410	1	Approved	\N	\N	Monthly	Seeded request	\N
23	4	Approved	\N	7	Monthly	Seeded assignment	\N
653	8	Approved	Expert	4	Weekly	Seeded request	\N
59	12	Approved	Expert	2	\N	Seeded assignment	2025-11-27 05:54:27.264874
961	19	Approved	Advanced	\N	Daily	Seeded request	2025-11-25 05:53:27.264874
155	19	Requested	Beginner	\N	\N	Seeded request	2025-11-24 15:54:27.264874
326	6	Approved	Beginner	10	Rarely	Seeded assignment	2025-11-08 17:41:27.264874
806	23	Approved	\N	\N	\N	Seeded request	2025-11-28 17:30:27.264874
834	25	Requested	Expert	5	\N	Seeded assignment	\N
267	11	Approved	Expert	\N	Daily	Seeded assignment	\N
888	22	Approved	\N	\N	Rarely	Seeded assignment	\N
587	19	Requested	Expert	\N	\N	Seeded assignment	2025-11-22 09:52:27.264874
915	7	Approved	\N	\N	Monthly	Seeded request	\N
655	10	Approved	Intermediate	10	\N	Seeded request	2025-11-16 14:43:27.264874
136	24	Approved	Expert	7	Rarely	Seeded assignment	\N
372	9	Approved	Advanced	\N	\N	Seeded request	2025-11-16 10:03:27.264874
167	10	Approved	\N	\N	Rarely	Seeded request	2025-11-30 08:16:27.264874
985	5	Approved	\N	\N	Daily	Seeded assignment	\N
618	3	Requested	\N	2	Monthly	Seeded assignment	\N
703	20	Approved	\N	9	Daily	Seeded assignment	\N
800	7	Requested	Beginner	\N	Daily	Seeded request	\N
470	13	Requested	\N	\N	Monthly	Seeded request	2025-11-06 03:21:27.264874
664	21	Approved	Beginner	\N	Daily	Seeded assignment	\N
352	20	Requested	\N	\N	Daily	Seeded assignment	2025-11-16 00:38:27.264874
682	9	Approved	\N	0	Weekly	Seeded assignment	\N
958	10	Approved	\N	5	\N	Seeded request	\N
858	3	Approved	\N	0	Rarely	Seeded request	2025-11-20 21:18:27.264874
64	25	Requested	\N	\N	Rarely	Seeded assignment	2025-11-04 22:55:27.264874
605	13	Approved	Intermediate	8	\N	Seeded assignment	2025-11-25 07:23:27.264874
566	23	Requested	Intermediate	0	\N	Seeded request	\N
825	21	Approved	Intermediate	0	Daily	Seeded assignment	\N
555	21	Approved	Beginner	\N	Monthly	Seeded request	\N
37	6	Approved	Advanced	5	Daily	Seeded assignment	2025-11-05 20:07:27.264874
619	16	Approved	Advanced	4	\N	Seeded assignment	2025-11-15 02:04:27.264874
227	3	Requested	Intermediate	6	Rarely	Seeded assignment	2025-11-21 20:47:27.264874
578	23	Requested	Advanced	4	\N	Seeded request	\N
660	12	Approved	Intermediate	10	Weekly	Seeded assignment	\N
685	19	Requested	Intermediate	9	\N	Seeded assignment	2025-11-17 04:17:27.264874
701	8	Requested	Intermediate	4	Monthly	Seeded assignment	\N
946	7	Approved	Intermediate	2	\N	Seeded assignment	2025-11-13 20:01:27.264874
86	4	Approved	\N	2	\N	Seeded request	\N
799	5	Approved	\N	0	Monthly	Seeded assignment	2025-11-29 05:24:27.264874
590	7	Approved	Beginner	7	Monthly	Seeded request	\N
60	1	Requested	Expert	\N	Weekly	Seeded request	\N
951	11	Approved	Advanced	\N	Daily	Seeded request	2025-11-30 22:56:27.264874
289	8	Requested	\N	7	\N	Seeded request	2025-11-30 16:20:27.264874
404	23	Approved	Beginner	7	\N	Seeded request	\N
187	13	Approved	Beginner	\N	Monthly	Seeded assignment	2025-11-25 23:12:27.264874
765	21	Requested	Advanced	7	\N	Seeded assignment	2025-11-04 15:03:27.264874
525	3	Requested	Beginner	\N	Daily	Seeded assignment	\N
510	22	Requested	Expert	2	Rarely	Seeded request	\N
603	8	Requested	\N	\N	\N	Seeded assignment	2025-11-27 17:13:27.264874
111	16	Approved	\N	5	Weekly	Seeded assignment	2025-11-11 18:12:27.264874
562	16	Approved	\N	6	Monthly	Seeded assignment	2025-11-11 13:31:27.264874
845	18	Approved	Beginner	8	Daily	Seeded request	\N
844	11	Approved	\N	4	\N	Seeded request	2025-11-07 19:45:27.264874
109	10	Requested	Expert	\N	\N	Seeded assignment	2025-11-13 02:49:27.264874
42	20	Approved	Advanced	\N	Rarely	Seeded assignment	\N
793	4	Approved	Beginner	6	\N	Seeded request	2025-11-23 20:38:27.264874
909	22	Requested	Beginner	1	Rarely	Seeded assignment	\N
905	1	Requested	\N	0	\N	Seeded assignment	\N
334	18	Requested	Advanced	6	Daily	Seeded request	2025-11-29 03:54:27.264874
396	6	Requested	Advanced	\N	Rarely	Seeded request	\N
275	9	Approved	\N	3	Weekly	Seeded request	2025-11-16 23:57:27.264874
103	3	Approved	Intermediate	10	\N	Seeded assignment	\N
203	12	Requested	\N	\N	\N	Seeded assignment	\N
245	1	Requested	\N	\N	Monthly	Seeded assignment	2025-11-06 11:58:27.264874
8	19	Approved	Advanced	9	Weekly	Seeded request	\N
895	22	Approved	\N	\N	\N	Seeded request	2025-11-21 05:54:27.264874
698	20	Requested	\N	2	Weekly	Seeded request	2025-11-26 04:02:27.264874
309	5	Requested	\N	\N	Weekly	Seeded request	\N
451	3	Requested	Beginner	\N	Monthly	Seeded assignment	2025-11-13 06:21:27.264874
181	23	Approved	Expert	\N	\N	Seeded assignment	\N
666	1	Requested	Expert	9	\N	Seeded assignment	\N
535	8	Approved	Expert	\N	Monthly	Seeded assignment	\N
670	13	Approved	Expert	\N	Weekly	Seeded assignment	2025-12-01 20:03:27.264874
628	19	Approved	Beginner	\N	\N	Seeded assignment	\N
58	1	Approved	Expert	\N	Rarely	Seeded request	2025-11-17 22:03:27.264874
410	9	Approved	Advanced	\N	Rarely	Seeded request	\N
300	8	Approved	Expert	\N	Rarely	Seeded assignment	2025-11-14 21:35:27.264874
658	11	Requested	Advanced	\N	Weekly	Seeded assignment	2025-11-21 07:53:27.264874
347	9	Approved	\N	\N	\N	Seeded request	2025-11-30 03:19:27.264874
264	24	Requested	\N	5	Monthly	Seeded assignment	\N
249	12	Approved	Advanced	2	Rarely	Seeded assignment	2025-11-15 12:16:27.264874
324	25	Requested	\N	8	Monthly	Seeded request	\N
122	19	Requested	Beginner	\N	Rarely	Seeded request	2025-12-03 03:03:27.264874
519	6	Requested	Beginner	\N	Rarely	Seeded assignment	2025-11-06 14:50:27.264874
565	8	Approved	Beginner	\N	Monthly	Seeded assignment	\N
288	17	Approved	Expert	\N	\N	Seeded assignment	\N
846	6	Approved	Expert	10	Rarely	Seeded assignment	2025-11-13 02:14:27.264874
754	22	Requested	Advanced	6	Rarely	Seeded request	2025-11-21 19:47:27.264874
981	16	Requested	\N	7	Daily	Seeded assignment	\N
194	12	Approved	\N	5	\N	Seeded request	2025-11-23 20:23:27.264874
254	6	Approved	Expert	7	Daily	Seeded assignment	2025-11-30 14:32:27.264874
386	18	Approved	\N	\N	Daily	Seeded assignment	\N
531	19	Approved	\N	\N	\N	Seeded request	2025-11-18 03:40:27.264874
424	25	Requested	\N	\N	\N	Seeded request	\N
668	16	Approved	\N	\N	\N	Seeded assignment	\N
572	22	Requested	Beginner	1	\N	Seeded assignment	\N
860	22	Approved	Intermediate	2	\N	Seeded request	\N
323	9	Requested	Advanced	6	Daily	Seeded request	2025-11-23 06:15:27.264874
265	21	Approved	Beginner	\N	\N	Seeded assignment	\N
408	25	Requested	\N	7	\N	Seeded assignment	\N
132	12	Requested	Intermediate	\N	Monthly	Seeded assignment	2025-11-12 05:55:27.264874
276	24	Approved	Beginner	\N	Monthly	Seeded assignment	2025-11-06 17:31:27.264874
340	6	Requested	Advanced	\N	Daily	Seeded assignment	2025-11-13 19:22:27.264874
89	17	Requested	Advanced	\N	Rarely	Seeded request	2025-11-10 00:13:27.264874
394	20	Approved	\N	0	Rarely	Seeded assignment	2025-11-24 15:16:27.264874
640	17	Requested	\N	8	Rarely	Seeded assignment	\N
229	16	Approved	\N	\N	\N	Seeded request	\N
721	12	Approved	Beginner	2	Weekly	Seeded assignment	\N
561	16	Approved	\N	10	Monthly	Seeded assignment	\N
337	7	Requested	Advanced	9	Weekly	Seeded request	2025-11-11 08:13:27.264874
574	9	Approved	Expert	\N	Rarely	Seeded assignment	\N
695	23	Approved	\N	\N	Monthly	Seeded assignment	\N
918	25	Approved	Intermediate	3	Daily	Seeded request	2025-11-13 13:19:27.264874
28	19	Requested	Beginner	7	\N	Seeded request	2025-11-14 00:18:27.264874
22	1	Requested	Beginner	\N	\N	Seeded assignment	2025-12-02 20:33:27.264874
661	6	Approved	Beginner	0	Rarely	Seeded request	\N
987	8	Approved	\N	5	Rarely	Seeded assignment	2025-11-11 11:46:27.264874
974	10	Approved	\N	6	\N	Seeded assignment	2025-11-06 20:17:27.264874
496	24	Approved	Beginner	2	Weekly	Seeded request	\N
737	23	Requested	Expert	\N	\N	Seeded assignment	\N
335	6	Approved	\N	1	\N	Seeded assignment	\N
485	17	Approved	Expert	1	\N	Seeded assignment	2025-11-09 03:17:27.264874
70	12	Approved	Advanced	9	Monthly	Seeded assignment	\N
233	17	Requested	\N	5	Monthly	Seeded assignment	\N
178	23	Approved	\N	\N	\N	Seeded assignment	2025-11-15 00:12:27.264874
192	3	Requested	Intermediate	5	\N	Seeded request	2025-11-16 02:14:27.264874
264	8	Requested	\N	3	Weekly	Seeded request	2025-11-18 07:14:27.264874
260	19	Requested	Expert	9	\N	Seeded assignment	2025-11-30 05:18:27.264874
395	1	Approved	Advanced	7	Monthly	Seeded request	2025-11-10 13:46:27.264874
854	20	Approved	\N	\N	\N	Seeded assignment	\N
947	22	Approved	Intermediate	\N	\N	Seeded request	2025-12-02 23:48:27.264874
526	23	Approved	Advanced	9	Monthly	Seeded request	\N
535	24	Requested	Advanced	2	Rarely	Seeded request	2025-11-30 03:05:27.264874
559	23	Approved	Beginner	\N	Weekly	Seeded request	\N
759	21	Approved	Beginner	1	\N	Seeded request	2025-11-21 23:15:27.264874
68	24	Approved	\N	\N	Weekly	Seeded assignment	\N
126	16	Requested	Beginner	\N	Weekly	Seeded assignment	\N
474	25	Requested	Intermediate	\N	Weekly	Seeded assignment	\N
91	17	Approved	Intermediate	\N	Rarely	Seeded assignment	2025-11-08 14:51:27.264874
839	23	Approved	\N	3	\N	Seeded request	\N
104	7	Approved	\N	\N	\N	Seeded request	2025-11-11 20:33:27.264874
659	5	Requested	Expert	10	Daily	Seeded assignment	\N
576	21	Requested	Advanced	\N	\N	Seeded assignment	\N
242	20	Approved	Intermediate	3	Daily	Seeded request	\N
654	21	Requested	Expert	9	\N	Seeded assignment	2025-11-06 22:22:27.264874
682	11	Requested	Expert	\N	Rarely	Seeded assignment	2025-11-25 19:39:27.264874
21	10	Approved	Beginner	1	\N	Seeded assignment	\N
783	19	Approved	Advanced	0	\N	Seeded request	2025-11-15 18:33:27.264874
105	12	Approved	Intermediate	\N	Daily	Seeded request	2025-11-08 07:48:27.264874
145	7	Approved	Beginner	10	\N	Seeded assignment	2025-11-22 03:48:27.264874
267	9	Approved	\N	\N	\N	Seeded assignment	2025-11-29 03:52:27.264874
49	11	Approved	\N	10	Weekly	Seeded request	\N
569	17	Requested	\N	9	Daily	Seeded assignment	\N
22	11	Approved	Beginner	\N	\N	Seeded request	\N
790	12	Approved	Beginner	\N	Rarely	Seeded request	\N
984	25	Requested	Expert	\N	Daily	Seeded assignment	\N
338	3	Approved	Intermediate	4	Rarely	Seeded assignment	2025-12-01 20:02:27.264874
716	13	Approved	\N	\N	\N	Seeded assignment	\N
916	13	Approved	Intermediate	9	\N	Seeded assignment	2025-11-09 04:08:27.264874
788	16	Requested	\N	8	Rarely	Seeded assignment	\N
161	13	Approved	Intermediate	0	Daily	Seeded assignment	2025-11-08 06:48:27.264874
476	5	Approved	Expert	4	\N	Seeded assignment	\N
586	22	Approved	\N	4	Monthly	Seeded assignment	2025-11-17 00:29:27.264874
583	20	Requested	Expert	\N	\N	Seeded assignment	2025-11-06 14:56:27.264874
468	10	Approved	Expert	3	Daily	Seeded request	\N
558	1	Approved	Beginner	6	Weekly	Seeded assignment	2025-12-03 00:31:27.264874
430	22	Approved	Advanced	10	Rarely	Seeded request	\N
841	25	Approved	Expert	\N	Daily	Seeded assignment	\N
936	20	Approved	\N	\N	Weekly	Seeded assignment	\N
45	11	Approved	Expert	\N	Daily	Seeded assignment	2025-11-15 10:35:27.264874
764	16	Approved	Advanced	\N	\N	Seeded assignment	2025-11-21 11:55:27.264874
243	7	Approved	\N	3	\N	Seeded request	2025-11-13 13:51:27.264874
712	10	Requested	\N	\N	Daily	Seeded request	\N
60	11	Approved	Advanced	9	\N	Seeded assignment	\N
607	3	Approved	Expert	0	\N	Seeded request	2025-11-09 05:31:27.264874
3	5	Approved	Advanced	\N	\N	Seeded assignment	2025-12-02 01:46:27.264874
328	19	Requested	\N	4	Weekly	Seeded request	\N
358	24	Requested	\N	6	Monthly	Seeded assignment	2025-11-10 07:53:27.264874
156	22	Approved	Intermediate	\N	\N	Seeded assignment	\N
220	13	Approved	\N	7	\N	Seeded assignment	\N
633	23	Approved	Advanced	8	Monthly	Seeded assignment	\N
499	17	Approved	Advanced	\N	\N	Seeded request	2025-11-30 01:17:27.264874
477	16	Requested	\N	\N	\N	Seeded assignment	\N
393	9	Requested	Expert	\N	\N	Seeded assignment	\N
290	18	Requested	Expert	\N	\N	Seeded request	\N
534	1	Approved	Intermediate	9	\N	Seeded assignment	\N
406	4	Requested	Beginner	0	\N	Seeded request	2025-11-07 01:21:27.264874
388	13	Approved	\N	10	Daily	Seeded request	\N
327	11	Approved	Advanced	\N	\N	Seeded request	2025-11-09 06:51:27.264874
392	21	Approved	Advanced	0	Daily	Seeded assignment	\N
504	23	Requested	Beginner	3	Rarely	Seeded assignment	\N
146	7	Approved	Beginner	\N	Daily	Seeded assignment	2025-11-21 13:59:27.264874
272	19	Approved	\N	\N	Monthly	Seeded assignment	2025-11-16 05:17:27.264874
116	9	Requested	Expert	\N	Daily	Seeded request	2025-11-04 18:11:27.264874
113	24	Requested	Expert	\N	\N	Seeded assignment	\N
844	1	Requested	\N	\N	Weekly	Seeded request	\N
231	19	Approved	Beginner	0	\N	Seeded assignment	2025-11-20 15:52:27.264874
412	25	Requested	Intermediate	0	Monthly	Seeded request	\N
520	1	Approved	Expert	0	Monthly	Seeded request	2025-11-03 23:01:27.264874
688	1	Approved	Expert	6	\N	Seeded request	\N
428	7	Approved	Intermediate	\N	\N	Seeded assignment	\N
768	12	Approved	Expert	2	Monthly	Seeded request	2025-11-20 05:57:27.264874
132	22	Approved	\N	\N	Rarely	Seeded assignment	\N
540	17	Approved	\N	5	\N	Seeded assignment	2025-11-14 09:45:27.264874
686	7	Requested	Expert	\N	\N	Seeded request	2025-11-05 07:29:27.264874
376	10	Requested	Advanced	\N	Daily	Seeded request	2025-11-23 07:07:27.264874
365	17	Requested	\N	4	Weekly	Seeded request	\N
469	11	Approved	\N	\N	Daily	Seeded assignment	\N
457	1	Approved	Expert	6	\N	Seeded assignment	2025-11-26 22:26:27.264874
118	19	Approved	\N	\N	Daily	Seeded assignment	\N
812	23	Approved	Expert	\N	Monthly	Seeded assignment	\N
723	10	Requested	Intermediate	3	Daily	Seeded request	\N
25	8	Requested	Expert	\N	Monthly	Seeded assignment	2025-11-17 08:02:27.264874
548	13	Requested	Beginner	\N	\N	Seeded assignment	2025-11-24 23:15:27.264874
391	17	Requested	\N	2	Weekly	Seeded assignment	2025-11-06 13:58:27.264874
521	16	Approved	Expert	0	\N	Seeded request	\N
597	19	Approved	Intermediate	\N	Monthly	Seeded request	\N
772	13	Requested	Advanced	3	\N	Seeded request	2025-11-13 00:53:27.264874
658	9	Approved	Expert	5	\N	Seeded request	2025-11-20 13:22:27.264874
426	17	Approved	\N	\N	Weekly	Seeded assignment	\N
501	1	Requested	\N	\N	Rarely	Seeded request	\N
207	22	Approved	Advanced	7	Monthly	Seeded assignment	2025-11-12 17:02:27.264874
221	24	Requested	Beginner	1	Weekly	Seeded request	2025-11-30 00:08:27.264874
402	11	Approved	Intermediate	4	Daily	Seeded assignment	2025-11-11 11:32:27.264874
770	25	Approved	\N	8	\N	Seeded assignment	\N
433	25	Approved	Advanced	\N	Monthly	Seeded assignment	\N
567	9	Approved	Intermediate	8	\N	Seeded request	\N
26	8	Requested	Beginner	\N	\N	Seeded assignment	\N
140	10	Requested	\N	\N	\N	Seeded assignment	\N
243	23	Requested	Expert	\N	Weekly	Seeded assignment	2025-11-15 06:34:27.264874
518	6	Approved	\N	\N	\N	Seeded request	2025-11-07 08:36:27.264874
620	6	Approved	Advanced	8	Weekly	Seeded request	\N
98	23	Requested	\N	8	\N	Seeded assignment	2025-11-05 16:40:27.264874
722	21	Requested	Expert	2	\N	Seeded request	\N
538	5	Approved	Beginner	\N	Daily	Seeded request	2025-12-03 04:24:27.264874
33	7	Approved	Advanced	4	Monthly	Seeded request	2025-11-21 09:28:27.264874
79	4	Requested	\N	7	Rarely	Seeded assignment	2025-12-01 19:23:27.264874
369	3	Approved	Beginner	8	\N	Seeded assignment	2025-11-10 02:10:27.264874
700	6	Approved	\N	6	Weekly	Seeded request	\N
953	13	Requested	\N	4	Monthly	Seeded request	2025-11-24 20:05:27.264874
65	24	Requested	Beginner	10	Weekly	Seeded assignment	2025-12-01 04:55:27.264874
574	11	Requested	Beginner	2	\N	Seeded request	\N
196	8	Approved	Expert	0	Monthly	Seeded assignment	2025-11-06 06:03:27.264874
643	24	Approved	\N	6	Rarely	Seeded request	2025-11-23 18:02:27.264874
43	19	Requested	\N	\N	Weekly	Seeded assignment	2025-11-12 21:53:27.264874
403	21	Requested	Beginner	\N	\N	Seeded request	\N
936	12	Approved	Beginner	\N	Monthly	Seeded request	\N
244	21	Requested	Beginner	\N	\N	Seeded request	2025-11-12 20:36:27.264874
754	20	Requested	Beginner	4	Weekly	Seeded assignment	\N
29	4	Requested	\N	9	Daily	Seeded assignment	\N
178	7	Approved	Expert	2	\N	Seeded assignment	\N
577	6	Approved	Beginner	8	Rarely	Seeded assignment	\N
393	1	Approved	Intermediate	\N	Daily	Seeded request	2025-11-24 05:21:27.264874
539	12	Approved	\N	\N	Rarely	Seeded assignment	2025-11-09 17:47:27.264874
467	12	Approved	\N	0	\N	Seeded request	\N
757	13	Approved	\N	\N	Weekly	Seeded assignment	\N
355	17	Approved	\N	\N	Daily	Seeded assignment	\N
90	22	Approved	Beginner	8	\N	Seeded assignment	2025-11-08 20:11:27.264874
907	13	Requested	Expert	3	Rarely	Seeded assignment	\N
280	10	Approved	\N	9	\N	Seeded assignment	2025-11-30 17:07:27.264874
951	9	Requested	Beginner	6	Rarely	Seeded request	2025-11-05 12:10:27.264874
790	20	Requested	Intermediate	\N	Weekly	Seeded request	\N
904	18	Requested	\N	0	\N	Seeded assignment	\N
502	22	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-14 11:57:27.264874
171	18	Approved	Beginner	\N	Weekly	Seeded assignment	\N
464	3	Approved	Intermediate	9	Weekly	Seeded assignment	\N
150	5	Approved	\N	0	Weekly	Seeded assignment	\N
526	7	Approved	\N	9	\N	Seeded request	\N
332	17	Requested	\N	\N	Monthly	Seeded request	2025-11-03 20:57:27.264874
596	25	Approved	\N	\N	\N	Seeded assignment	\N
839	7	Approved	Advanced	\N	Daily	Seeded assignment	\N
899	8	Approved	Beginner	2	\N	Seeded request	\N
46	17	Requested	Intermediate	10	Daily	Seeded request	2025-11-07 11:01:27.264874
917	13	Approved	Expert	\N	Weekly	Seeded assignment	2025-11-13 02:10:27.264874
387	4	Approved	Intermediate	\N	Weekly	Seeded assignment	2025-11-25 09:40:27.264874
621	1	Approved	Expert	9	Rarely	Seeded assignment	\N
863	24	Requested	\N	0	Monthly	Seeded assignment	\N
76	3	Approved	\N	3	Monthly	Seeded assignment	2025-11-25 07:04:27.264874
275	11	Approved	Intermediate	7	Daily	Seeded assignment	\N
649	19	Approved	Beginner	5	Rarely	Seeded assignment	2025-11-27 00:07:27.264874
694	24	Approved	\N	\N	\N	Seeded request	\N
307	8	Approved	\N	0	Rarely	Seeded assignment	\N
78	21	Approved	\N	0	Rarely	Seeded assignment	\N
149	8	Approved	Expert	4	\N	Seeded request	\N
611	20	Approved	Expert	\N	Weekly	Seeded assignment	\N
334	3	Approved	\N	3	\N	Seeded request	\N
452	6	Approved	\N	9	Weekly	Seeded assignment	\N
121	19	Requested	Advanced	8	Monthly	Seeded assignment	\N
634	19	Requested	\N	\N	Monthly	Seeded assignment	\N
888	12	Approved	Beginner	7	\N	Seeded assignment	\N
148	12	Approved	Intermediate	0	Daily	Seeded assignment	2025-11-15 22:15:27.264874
236	12	Approved	Beginner	7	Weekly	Seeded assignment	\N
845	3	Approved	Expert	9	Rarely	Seeded assignment	\N
720	16	Approved	Beginner	3	Rarely	Seeded assignment	2025-11-18 13:45:27.264874
792	5	Approved	\N	\N	\N	Seeded request	2025-11-28 23:26:27.264874
726	11	Approved	\N	5	\N	Seeded assignment	2025-11-13 06:49:27.264874
784	5	Requested	Intermediate	6	\N	Seeded request	\N
878	5	Requested	\N	4	Monthly	Seeded request	\N
70	20	Requested	Beginner	\N	Weekly	Seeded assignment	\N
718	24	Approved	\N	1	\N	Seeded request	2025-11-24 15:59:27.264874
713	16	Requested	\N	3	Monthly	Seeded assignment	\N
760	20	Requested	Intermediate	\N	\N	Seeded request	2025-11-24 04:01:27.264874
350	1	Requested	Beginner	\N	\N	Seeded assignment	2025-11-25 13:53:27.264874
429	24	Approved	Beginner	\N	Weekly	Seeded assignment	\N
396	25	Approved	\N	\N	Daily	Seeded assignment	2025-11-22 22:12:27.264874
801	23	Requested	\N	\N	\N	Seeded request	2025-11-14 18:49:27.264874
818	25	Approved	Intermediate	6	Weekly	Seeded assignment	\N
177	6	Approved	Beginner	8	Rarely	Seeded request	\N
201	20	Requested	\N	9	Monthly	Seeded assignment	2025-11-28 06:11:27.264874
535	10	Requested	\N	9	\N	Seeded assignment	2025-11-13 11:14:27.264874
652	10	Requested	Advanced	5	Daily	Seeded request	\N
630	23	Requested	\N	7	Weekly	Seeded request	\N
3	20	Approved	Advanced	\N	Rarely	Seeded assignment	\N
93	7	Requested	Beginner	4	Rarely	Seeded request	2025-11-11 17:40:27.264874
231	18	Approved	Intermediate	5	\N	Seeded assignment	2025-11-05 12:05:27.264874
967	22	Approved	\N	8	Monthly	Seeded assignment	\N
732	22	Requested	\N	\N	Weekly	Seeded assignment	2025-11-25 07:55:27.264874
209	23	Requested	\N	\N	\N	Seeded assignment	\N
272	18	Approved	\N	9	\N	Seeded request	\N
455	23	Requested	\N	\N	Daily	Seeded request	\N
252	8	Requested	\N	7	Daily	Seeded request	2025-11-09 16:42:27.264874
277	21	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-27 06:04:27.264874
341	9	Approved	\N	\N	Rarely	Seeded assignment	\N
301	24	Approved	\N	\N	Rarely	Seeded request	\N
538	12	Approved	Beginner	6	Rarely	Seeded assignment	\N
401	24	Approved	\N	\N	Monthly	Seeded request	2025-11-19 20:00:27.264874
876	16	Approved	Expert	\N	\N	Seeded assignment	2025-11-05 04:10:27.264874
454	1	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
4	5	Approved	\N	\N	Monthly	Seeded request	\N
702	9	Requested	\N	4	\N	Seeded assignment	\N
641	9	Approved	Advanced	\N	\N	Seeded request	2025-11-17 07:11:27.264874
751	1	Approved	\N	2	Weekly	Seeded request	\N
180	22	Requested	Advanced	\N	Monthly	Seeded assignment	2025-11-03 10:31:27.264874
704	17	Approved	Intermediate	3	\N	Seeded assignment	\N
771	20	Requested	\N	\N	Weekly	Seeded assignment	\N
317	25	Requested	\N	6	Monthly	Seeded assignment	2025-11-13 09:57:27.264874
9	11	Requested	Advanced	2	Daily	Seeded assignment	\N
164	17	Approved	\N	3	Rarely	Seeded assignment	\N
960	19	Approved	Intermediate	\N	Rarely	Seeded assignment	\N
445	11	Approved	Beginner	\N	\N	Seeded assignment	\N
748	24	Approved	\N	5	\N	Seeded assignment	\N
871	22	Requested	Expert	1	Rarely	Seeded request	2025-11-19 20:07:27.264874
37	25	Approved	Beginner	\N	Monthly	Seeded request	2025-11-21 05:53:27.264874
982	20	Requested	\N	\N	Rarely	Seeded request	\N
881	4	Requested	Intermediate	5	Weekly	Seeded assignment	2025-11-27 10:57:27.264874
865	10	Requested	Intermediate	9	Weekly	Seeded assignment	\N
446	3	Requested	Advanced	5	Daily	Seeded request	\N
188	18	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
375	18	Approved	\N	8	\N	Seeded request	\N
878	12	Approved	\N	\N	Daily	Seeded assignment	\N
373	7	Approved	Expert	\N	Monthly	Seeded assignment	\N
117	9	Requested	Beginner	2	\N	Seeded request	2025-11-30 21:54:27.264874
129	1	Approved	Advanced	\N	Rarely	Seeded assignment	\N
888	5	Approved	Advanced	\N	\N	Seeded request	\N
236	5	Requested	Expert	4	Rarely	Seeded request	2025-11-27 11:18:27.264874
712	24	Approved	Advanced	0	Monthly	Seeded request	\N
425	19	Approved	Beginner	7	Daily	Seeded request	2025-11-18 11:09:27.264874
122	4	Requested	Advanced	8	\N	Seeded request	2025-11-13 23:34:27.264874
434	3	Requested	Intermediate	5	Rarely	Seeded assignment	\N
424	6	Requested	Intermediate	7	Rarely	Seeded assignment	2025-11-27 17:57:27.264874
618	19	Approved	Beginner	1	\N	Seeded request	2025-11-29 23:59:27.264874
628	4	Requested	Advanced	\N	Rarely	Seeded request	2025-12-02 23:52:27.264874
971	1	Approved	Beginner	5	Rarely	Seeded request	2025-12-01 13:57:27.264874
342	5	Requested	Intermediate	3	Rarely	Seeded assignment	2025-11-15 21:23:27.264874
744	22	Requested	Advanced	3	\N	Seeded request	\N
941	10	Requested	Advanced	\N	Weekly	Seeded request	\N
575	24	Approved	\N	\N	\N	Seeded assignment	\N
28	4	Requested	Intermediate	8	\N	Seeded request	\N
846	25	Requested	\N	10	\N	Seeded assignment	\N
322	13	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-21 22:59:27.264874
519	25	Requested	Intermediate	\N	\N	Seeded assignment	\N
804	10	Approved	\N	8	Monthly	Seeded assignment	\N
926	12	Approved	\N	\N	Weekly	Seeded request	\N
693	22	Approved	\N	4	Rarely	Seeded assignment	\N
943	12	Requested	Beginner	8	\N	Seeded assignment	2025-11-19 04:54:27.264874
254	25	Approved	\N	0	\N	Seeded request	\N
524	8	Approved	\N	6	\N	Seeded assignment	\N
803	10	Requested	Beginner	6	Weekly	Seeded request	2025-11-15 12:24:27.264874
756	23	Requested	\N	\N	\N	Seeded request	\N
260	18	Approved	\N	1	Monthly	Seeded request	\N
604	3	Approved	\N	4	Weekly	Seeded request	2025-12-01 02:29:27.264874
585	4	Approved	Beginner	8	Rarely	Seeded assignment	\N
692	10	Approved	\N	1	\N	Seeded assignment	\N
648	5	Requested	\N	3	\N	Seeded assignment	\N
390	16	Approved	\N	3	\N	Seeded assignment	2025-11-05 04:24:27.264874
95	9	Requested	Expert	7	Daily	Seeded assignment	\N
14	12	Approved	Beginner	1	\N	Seeded request	\N
339	7	Approved	Intermediate	1	\N	Seeded request	\N
101	7	Approved	Intermediate	\N	\N	Seeded assignment	\N
374	25	Approved	\N	5	Monthly	Seeded request	2025-11-14 23:09:27.264874
296	8	Approved	Advanced	\N	Rarely	Seeded assignment	\N
673	17	Approved	\N	4	Daily	Seeded assignment	\N
824	18	Approved	Beginner	\N	\N	Seeded assignment	\N
945	13	Approved	Expert	6	Daily	Seeded assignment	\N
634	18	Requested	Beginner	4	Monthly	Seeded request	\N
809	3	Approved	Intermediate	\N	Rarely	Seeded request	2025-11-15 02:25:27.264874
926	20	Approved	Beginner	1	\N	Seeded request	2025-11-17 05:24:27.264874
859	12	Approved	Expert	1	\N	Seeded assignment	\N
670	16	Approved	Expert	\N	\N	Seeded request	\N
154	18	Approved	Expert	\N	\N	Seeded assignment	\N
691	1	Approved	Expert	\N	Monthly	Seeded assignment	2025-11-27 11:03:27.264874
858	19	Approved	\N	5	Weekly	Seeded assignment	2025-11-08 17:01:27.264874
423	11	Approved	Expert	\N	Rarely	Seeded assignment	\N
229	13	Approved	\N	5	Rarely	Seeded assignment	\N
767	1	Approved	Advanced	\N	Monthly	Seeded request	\N
389	1	Approved	Expert	3	Daily	Seeded assignment	\N
151	7	Approved	\N	\N	\N	Seeded assignment	\N
108	10	Approved	Advanced	\N	Rarely	Seeded request	\N
872	7	Requested	Advanced	7	\N	Seeded assignment	\N
668	13	Approved	\N	9	Rarely	Seeded assignment	2025-12-01 08:48:27.264874
171	19	Requested	Expert	5	\N	Seeded assignment	\N
227	19	Approved	Advanced	\N	\N	Seeded request	2025-11-07 20:09:27.264874
454	9	Approved	\N	1	Rarely	Seeded assignment	\N
542	3	Approved	Advanced	4	Rarely	Seeded assignment	\N
828	9	Approved	\N	2	Monthly	Seeded assignment	\N
617	8	Approved	\N	\N	\N	Seeded assignment	\N
729	24	Requested	Advanced	10	\N	Seeded request	\N
751	9	Approved	Intermediate	4	Monthly	Seeded assignment	\N
623	9	Requested	Advanced	2	\N	Seeded assignment	\N
760	5	Approved	Intermediate	5	Weekly	Seeded request	\N
173	20	Approved	Intermediate	3	Monthly	Seeded assignment	2025-11-03 12:03:27.264874
725	25	Requested	\N	\N	\N	Seeded assignment	\N
56	24	Approved	\N	\N	Daily	Seeded assignment	2025-11-25 16:14:27.264874
438	22	Requested	\N	\N	Rarely	Seeded assignment	2025-12-01 21:43:27.264874
258	17	Approved	Expert	\N	\N	Seeded assignment	2025-12-02 12:03:27.264874
747	12	Requested	\N	3	Monthly	Seeded request	\N
811	16	Approved	\N	\N	\N	Seeded assignment	\N
982	12	Approved	\N	0	\N	Seeded assignment	\N
421	25	Approved	\N	\N	Rarely	Seeded assignment	\N
850	7	Approved	\N	10	\N	Seeded request	\N
768	5	Requested	\N	2	\N	Seeded assignment	\N
971	9	Approved	\N	0	\N	Seeded assignment	2025-11-08 03:33:27.264874
280	24	Requested	Expert	0	\N	Seeded request	2025-11-22 00:45:27.264874
93	23	Approved	\N	3	Monthly	Seeded assignment	2025-11-27 16:33:27.264874
458	8	Requested	Intermediate	\N	\N	Seeded assignment	\N
630	7	Requested	Advanced	10	\N	Seeded assignment	\N
834	6	Requested	\N	\N	Weekly	Seeded request	\N
233	21	Approved	\N	\N	Monthly	Seeded request	\N
364	5	Requested	Beginner	\N	Daily	Seeded request	2025-11-04 16:54:27.264874
669	1	Approved	Beginner	7	Monthly	Seeded request	2025-11-03 09:55:27.264874
508	6	Requested	Beginner	9	Rarely	Seeded request	\N
629	8	Approved	Beginner	\N	Monthly	Seeded request	\N
480	24	Approved	Expert	8	Weekly	Seeded assignment	2025-11-25 01:02:27.264874
313	3	Requested	Intermediate	3	\N	Seeded request	\N
198	8	Requested	\N	6	\N	Seeded request	\N
896	10	Requested	Beginner	9	Daily	Seeded assignment	2025-12-02 06:30:27.264874
360	13	Requested	\N	9	Rarely	Seeded assignment	\N
11	6	Requested	Expert	\N	Monthly	Seeded assignment	\N
718	10	Requested	Advanced	2	\N	Seeded assignment	\N
645	18	Approved	Expert	\N	\N	Seeded assignment	\N
133	25	Approved	Beginner	10	Monthly	Seeded request	\N
628	3	Requested	\N	\N	Rarely	Seeded request	2025-11-26 11:20:27.264874
755	25	Approved	\N	5	Daily	Seeded assignment	2025-12-03 00:48:27.264874
595	24	Approved	Advanced	5	Monthly	Seeded assignment	2025-11-21 11:05:27.264874
626	8	Approved	Intermediate	\N	\N	Seeded request	\N
857	19	Approved	\N	0	Weekly	Seeded assignment	\N
587	4	Requested	Beginner	\N	Daily	Seeded assignment	2025-11-04 08:21:27.264874
201	12	Requested	\N	6	\N	Seeded request	2025-11-27 11:59:27.264874
122	3	Approved	\N	4	\N	Seeded request	2025-11-18 03:12:27.264874
230	23	Requested	Expert	7	\N	Seeded assignment	\N
363	1	Approved	\N	7	\N	Seeded assignment	\N
172	25	Requested	Expert	\N	Weekly	Seeded request	\N
484	21	Approved	Advanced	\N	\N	Seeded request	2025-11-19 11:07:27.264874
74	24	Approved	Advanced	8	\N	Seeded assignment	\N
817	5	Approved	\N	2	\N	Seeded request	\N
736	3	Approved	Beginner	\N	Daily	Seeded assignment	\N
87	23	Approved	Expert	2	Daily	Seeded request	2025-11-15 06:59:27.264874
396	1	Approved	\N	\N	Daily	Seeded assignment	\N
597	23	Approved	Beginner	8	Rarely	Seeded request	\N
665	20	Approved	\N	6	\N	Seeded assignment	2025-11-25 05:21:27.264874
245	6	Requested	\N	\N	Daily	Seeded assignment	\N
935	1	Approved	\N	9	Rarely	Seeded request	2025-11-06 02:47:27.264874
193	19	Approved	Beginner	5	Weekly	Seeded request	\N
32	3	Approved	\N	8	Rarely	Seeded assignment	\N
766	8	Approved	Expert	8	\N	Seeded assignment	2025-11-09 17:09:27.264874
932	24	Requested	\N	5	Rarely	Seeded assignment	\N
17	13	Approved	Advanced	8	Daily	Seeded request	2025-11-13 10:00:27.264874
645	23	Approved	\N	8	Monthly	Seeded request	\N
374	9	Approved	\N	\N	\N	Seeded assignment	\N
328	7	Approved	Beginner	\N	Rarely	Seeded request	\N
710	10	Approved	Intermediate	5	Monthly	Seeded assignment	\N
55	9	Approved	Expert	\N	\N	Seeded assignment	2025-11-16 13:36:27.264874
356	25	Approved	Expert	4	Monthly	Seeded assignment	2025-11-06 12:35:27.264874
731	23	Requested	Intermediate	3	Weekly	Seeded assignment	2025-11-16 00:07:27.264874
679	22	Approved	\N	1	Daily	Seeded assignment	\N
822	16	Requested	Beginner	1	Weekly	Seeded request	2025-11-25 18:19:27.264874
93	18	Approved	Expert	\N	Weekly	Seeded request	\N
292	11	Approved	\N	0	Monthly	Seeded assignment	\N
644	13	Approved	Advanced	9	Monthly	Seeded assignment	\N
680	8	Requested	Expert	\N	Monthly	Seeded assignment	2025-11-08 23:37:27.264874
769	24	Approved	\N	\N	Rarely	Seeded assignment	\N
367	4	Approved	Expert	\N	Daily	Seeded assignment	2025-11-04 05:05:27.264874
405	11	Approved	\N	\N	Daily	Seeded assignment	\N
524	13	Requested	Advanced	\N	Daily	Seeded request	2025-11-10 18:23:27.264874
184	3	Requested	\N	7	Rarely	Seeded request	\N
215	1	Approved	Intermediate	7	\N	Seeded request	\N
828	25	Approved	Intermediate	5	Daily	Seeded assignment	2025-11-15 17:01:27.264874
60	6	Approved	\N	10	Rarely	Seeded assignment	2025-11-08 12:43:27.264874
223	7	Approved	\N	\N	Rarely	Seeded assignment	\N
377	3	Requested	\N	8	Rarely	Seeded assignment	\N
516	24	Approved	Expert	\N	\N	Seeded assignment	\N
718	16	Requested	\N	\N	Rarely	Seeded request	2025-11-30 04:10:27.264874
914	13	Requested	Advanced	\N	\N	Seeded assignment	\N
429	16	Requested	\N	2	Weekly	Seeded request	2025-11-25 09:41:27.264874
966	22	Approved	Expert	\N	Monthly	Seeded request	2025-11-08 15:39:27.264874
109	13	Approved	Expert	4	Rarely	Seeded assignment	\N
482	23	Approved	Advanced	8	\N	Seeded request	\N
664	20	Approved	\N	\N	\N	Seeded request	\N
488	24	Requested	\N	5	Weekly	Seeded request	\N
825	12	Requested	\N	\N	Weekly	Seeded request	\N
199	6	Requested	\N	4	\N	Seeded assignment	\N
37	1	Approved	\N	4	\N	Seeded request	2025-11-29 21:17:27.264874
443	3	Approved	\N	10	Weekly	Seeded assignment	\N
10	19	Approved	Advanced	4	\N	Seeded request	2025-11-22 12:53:27.264874
947	21	Approved	Beginner	9	\N	Seeded request	\N
6	24	Approved	Beginner	\N	Weekly	Seeded assignment	\N
255	5	Requested	Advanced	2	\N	Seeded request	\N
686	19	Approved	\N	\N	Rarely	Seeded assignment	\N
129	25	Approved	Intermediate	7	\N	Seeded assignment	2025-11-10 12:21:27.264874
913	4	Requested	\N	\N	Rarely	Seeded assignment	2025-11-20 21:00:27.264874
63	7	Requested	Advanced	10	Rarely	Seeded assignment	2025-12-02 06:51:27.264874
340	1	Requested	Advanced	\N	Weekly	Seeded assignment	\N
134	24	Requested	\N	5	\N	Seeded assignment	\N
326	9	Requested	Advanced	2	\N	Seeded assignment	\N
661	1	Approved	\N	5	\N	Seeded request	\N
602	23	Approved	Expert	\N	Rarely	Seeded request	2025-11-06 04:03:27.264874
912	6	Approved	\N	9	Daily	Seeded assignment	2025-11-26 10:46:27.264874
707	25	Requested	Beginner	\N	Rarely	Seeded assignment	\N
27	11	Approved	Advanced	6	Monthly	Seeded request	2025-11-15 09:09:27.264874
560	10	Requested	\N	10	Weekly	Seeded request	2025-11-08 09:26:27.264874
498	22	Requested	Beginner	9	Rarely	Seeded assignment	2025-11-11 22:20:27.264874
447	17	Requested	Beginner	\N	Rarely	Seeded request	\N
883	11	Requested	Expert	8	\N	Seeded request	2025-11-14 07:37:27.264874
787	23	Approved	Beginner	4	Weekly	Seeded assignment	2025-11-27 19:10:27.264874
944	23	Approved	\N	3	Weekly	Seeded assignment	\N
366	4	Approved	Intermediate	0	Rarely	Seeded assignment	\N
903	25	Requested	Beginner	1	\N	Seeded assignment	\N
52	4	Approved	Expert	6	\N	Seeded assignment	\N
132	21	Approved	\N	6	Weekly	Seeded assignment	2025-11-10 10:39:27.264874
530	16	Approved	\N	\N	Daily	Seeded assignment	2025-11-13 20:38:27.264874
432	1	Approved	\N	\N	Rarely	Seeded assignment	\N
846	1	Requested	\N	9	\N	Seeded assignment	\N
135	5	Requested	Advanced	5	Daily	Seeded request	2025-11-07 09:40:27.264874
571	25	Requested	Advanced	4	Monthly	Seeded assignment	2025-11-20 05:28:27.264874
319	4	Requested	Intermediate	4	Monthly	Seeded request	\N
974	13	Requested	Expert	0	\N	Seeded assignment	\N
172	9	Approved	Intermediate	\N	Monthly	Seeded request	2025-11-04 22:29:27.264874
794	24	Requested	Advanced	10	Monthly	Seeded request	\N
649	23	Approved	Expert	0	\N	Seeded request	\N
92	8	Approved	\N	0	Daily	Seeded assignment	\N
625	1	Requested	\N	3	\N	Seeded request	\N
873	23	Requested	Intermediate	\N	Weekly	Seeded assignment	\N
940	10	Approved	\N	\N	\N	Seeded assignment	\N
492	9	Requested	\N	7	\N	Seeded assignment	2025-11-25 20:03:27.264874
131	13	Approved	\N	\N	\N	Seeded request	\N
677	6	Requested	\N	\N	Weekly	Seeded assignment	2025-11-03 07:19:27.264874
489	13	Approved	Intermediate	\N	\N	Seeded assignment	\N
256	3	Approved	Intermediate	2	\N	Seeded assignment	2025-11-12 04:35:27.264874
335	11	Approved	\N	\N	\N	Seeded assignment	\N
435	4	Requested	Intermediate	10	\N	Seeded assignment	\N
581	1	Approved	\N	\N	Rarely	Seeded request	\N
889	4	Approved	Expert	10	Rarely	Seeded assignment	\N
344	23	Approved	Beginner	10	\N	Seeded request	\N
622	25	Requested	Intermediate	\N	\N	Seeded assignment	\N
554	5	Approved	\N	1	Monthly	Seeded assignment	2025-11-13 06:39:27.264874
544	8	Requested	Expert	9	Monthly	Seeded request	2025-12-02 02:25:27.264874
341	25	Approved	Advanced	1	\N	Seeded request	2025-11-10 06:06:27.264874
866	11	Requested	Intermediate	\N	Rarely	Seeded request	\N
814	8	Requested	Intermediate	\N	\N	Seeded assignment	\N
443	4	Approved	\N	3	\N	Seeded request	\N
170	1	Approved	\N	10	\N	Seeded assignment	\N
875	4	Approved	Advanced	0	Weekly	Seeded request	\N
458	13	Approved	\N	4	Monthly	Seeded request	2025-11-03 23:27:27.264874
35	7	Requested	\N	2	Monthly	Seeded assignment	\N
94	10	Approved	\N	2	Daily	Seeded request	\N
285	11	Approved	Advanced	\N	\N	Seeded assignment	2025-11-16 06:18:27.264874
726	6	Requested	Intermediate	3	\N	Seeded request	\N
910	20	Approved	\N	4	Daily	Seeded assignment	2025-11-15 16:44:27.264874
162	10	Approved	Advanced	\N	Weekly	Seeded assignment	\N
38	1	Requested	\N	0	\N	Seeded assignment	\N
128	1	Approved	Intermediate	\N	\N	Seeded request	2025-11-21 16:52:27.264874
184	4	Requested	\N	9	Daily	Seeded assignment	\N
154	7	Requested	\N	3	Daily	Seeded assignment	\N
839	19	Approved	Expert	3	\N	Seeded assignment	\N
275	6	Approved	Intermediate	8	\N	Seeded request	\N
367	3	Requested	\N	9	Daily	Seeded assignment	\N
497	11	Approved	\N	9	Monthly	Seeded assignment	2025-11-16 00:15:27.264874
944	7	Approved	Intermediate	\N	Rarely	Seeded assignment	\N
948	6	Approved	Advanced	5	Daily	Seeded request	\N
933	23	Requested	Advanced	\N	Weekly	Seeded request	2025-11-26 18:40:27.264874
957	20	Approved	\N	5	\N	Seeded request	2025-11-19 08:56:27.264874
635	9	Requested	Beginner	\N	Daily	Seeded request	\N
310	12	Approved	Advanced	\N	\N	Seeded request	2025-11-27 02:58:27.264874
289	16	Approved	Beginner	\N	\N	Seeded assignment	2025-11-09 03:44:27.264874
603	16	Requested	Advanced	2	Weekly	Seeded assignment	2025-11-13 17:05:27.264874
268	12	Approved	Advanced	5	\N	Seeded assignment	2025-11-06 11:41:27.264874
549	12	Approved	\N	\N	Rarely	Seeded request	\N
523	19	Approved	Advanced	7	Daily	Seeded request	2025-11-16 06:50:27.264874
582	5	Approved	\N	3	Rarely	Seeded assignment	2025-11-24 17:08:27.264874
188	23	Approved	Beginner	\N	\N	Seeded request	2025-11-30 15:16:27.264874
836	12	Requested	\N	\N	\N	Seeded request	2025-11-27 04:37:27.264874
550	11	Approved	Beginner	4	\N	Seeded request	2025-11-03 19:08:27.264874
113	16	Approved	\N	\N	\N	Seeded assignment	2025-11-16 06:50:27.264874
776	7	Requested	\N	2	Rarely	Seeded request	\N
360	8	Approved	Intermediate	\N	Weekly	Seeded request	\N
725	1	Approved	\N	\N	Monthly	Seeded request	\N
739	16	Requested	Advanced	2	\N	Seeded assignment	2025-11-07 12:57:27.264874
112	3	Approved	Advanced	8	Rarely	Seeded request	\N
71	13	Requested	Beginner	\N	\N	Seeded assignment	2025-11-21 15:25:27.264874
344	7	Approved	\N	9	Monthly	Seeded request	\N
248	21	Requested	Expert	\N	Weekly	Seeded request	2025-11-27 10:17:27.264874
101	18	Approved	\N	3	Daily	Seeded assignment	2025-11-15 03:47:27.264874
736	4	Approved	Expert	7	\N	Seeded assignment	2025-11-23 08:25:27.264874
692	16	Requested	Expert	9	Monthly	Seeded assignment	\N
435	3	Requested	Advanced	\N	Monthly	Seeded assignment	\N
120	12	Requested	Expert	0	\N	Seeded assignment	\N
652	16	Requested	Advanced	7	Rarely	Seeded request	2025-11-16 22:53:27.264874
802	18	Approved	\N	\N	\N	Seeded assignment	2025-11-04 13:02:27.264874
555	20	Requested	Advanced	0	Weekly	Seeded assignment	\N
78	22	Requested	\N	9	\N	Seeded request	2025-11-29 17:13:27.264874
323	6	Approved	Expert	0	Weekly	Seeded assignment	2025-11-16 18:48:27.264874
664	12	Requested	\N	7	Weekly	Seeded request	\N
494	16	Requested	\N	\N	Weekly	Seeded assignment	\N
906	8	Requested	Intermediate	\N	\N	Seeded assignment	\N
282	13	Approved	\N	6	Weekly	Seeded assignment	\N
733	20	Requested	\N	10	Rarely	Seeded request	\N
939	17	Approved	Beginner	\N	Weekly	Seeded request	2025-11-14 21:49:27.264874
669	25	Requested	Expert	2	\N	Seeded assignment	2025-11-12 06:44:27.264874
928	16	Approved	Intermediate	\N	Rarely	Seeded request	\N
305	10	Requested	\N	9	Weekly	Seeded assignment	\N
574	6	Requested	Advanced	\N	Rarely	Seeded request	\N
127	17	Approved	\N	0	Monthly	Seeded request	2025-11-30 02:45:27.264874
319	3	Approved	Expert	\N	Monthly	Seeded assignment	\N
600	3	Approved	\N	\N	Daily	Seeded assignment	\N
927	5	Approved	\N	\N	\N	Seeded request	2025-11-16 02:56:27.264874
300	16	Requested	Expert	\N	Daily	Seeded assignment	\N
318	10	Approved	Advanced	\N	\N	Seeded assignment	\N
594	5	Requested	Beginner	7	Weekly	Seeded request	\N
709	25	Approved	\N	1	Rarely	Seeded request	\N
279	1	Requested	Intermediate	\N	Daily	Seeded assignment	\N
366	3	Requested	Expert	\N	Rarely	Seeded assignment	\N
876	10	Approved	\N	\N	Weekly	Seeded assignment	\N
209	18	Approved	Advanced	2	\N	Seeded assignment	\N
42	21	Approved	\N	\N	\N	Seeded request	\N
755	1	Approved	\N	\N	Weekly	Seeded request	\N
272	23	Requested	\N	6	Daily	Seeded assignment	\N
223	23	Requested	Advanced	2	\N	Seeded request	\N
620	11	Requested	\N	5	Weekly	Seeded assignment	\N
684	5	Approved	\N	4	Daily	Seeded assignment	2025-11-28 09:42:27.264874
518	11	Requested	Intermediate	\N	Weekly	Seeded request	2025-11-27 21:20:27.264874
378	24	Approved	Advanced	9	Monthly	Seeded assignment	\N
812	19	Approved	Beginner	10	Daily	Seeded request	\N
321	5	Approved	\N	6	\N	Seeded request	2025-11-07 17:07:27.264874
625	9	Approved	\N	9	\N	Seeded assignment	\N
330	11	Approved	\N	10	\N	Seeded assignment	2025-11-28 20:23:27.264874
856	18	Approved	\N	\N	Daily	Seeded request	\N
665	12	Requested	\N	3	\N	Seeded request	2025-12-03 01:11:27.264874
655	13	Requested	Beginner	8	Daily	Seeded assignment	2025-11-29 08:21:27.264874
75	8	Approved	\N	\N	\N	Seeded request	2025-11-22 21:50:27.264874
987	16	Approved	Beginner	0	Monthly	Seeded assignment	2025-11-22 09:17:27.264874
118	23	Approved	\N	9	Weekly	Seeded request	\N
238	20	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-07 22:04:27.264874
397	11	Approved	Beginner	6	Rarely	Seeded assignment	2025-11-12 06:50:27.264874
456	4	Approved	Beginner	10	Weekly	Seeded assignment	\N
172	1	Requested	Advanced	\N	\N	Seeded request	\N
229	8	Requested	Beginner	4	Daily	Seeded request	\N
425	7	Approved	\N	\N	\N	Seeded request	\N
939	21	Approved	\N	\N	Monthly	Seeded assignment	\N
84	10	Requested	\N	\N	\N	Seeded assignment	2025-11-20 09:00:27.264874
543	9	Approved	Beginner	8	Monthly	Seeded assignment	2025-11-05 11:53:27.264874
932	10	Approved	Advanced	4	Rarely	Seeded request	\N
293	9	Requested	Intermediate	0	Weekly	Seeded assignment	\N
373	19	Requested	\N	10	Daily	Seeded request	2025-11-25 08:41:27.264874
800	3	Approved	Beginner	\N	Monthly	Seeded request	2025-11-25 20:19:27.264874
166	8	Approved	Expert	2	Daily	Seeded request	\N
329	21	Approved	\N	2	Weekly	Seeded assignment	2025-11-18 03:51:27.264874
310	5	Approved	Expert	\N	Rarely	Seeded assignment	2025-12-01 09:29:27.264874
813	4	Approved	Expert	8	Rarely	Seeded assignment	2025-11-04 15:20:27.264874
687	1	Approved	\N	\N	Daily	Seeded request	\N
314	16	Approved	\N	1	Weekly	Seeded assignment	\N
419	16	Approved	\N	6	Weekly	Seeded assignment	2025-11-27 00:59:27.264874
662	20	Requested	Expert	\N	Rarely	Seeded assignment	2025-11-14 15:28:27.264874
104	18	Approved	\N	6	Rarely	Seeded request	\N
777	12	Approved	Advanced	9	Daily	Seeded assignment	2025-11-16 18:00:27.264874
180	21	Requested	Expert	9	Daily	Seeded assignment	\N
74	10	Requested	Expert	\N	Rarely	Seeded request	2025-11-12 14:47:27.264874
955	25	Approved	\N	\N	\N	Seeded assignment	2025-11-18 06:13:27.264874
965	22	Requested	\N	3	Rarely	Seeded assignment	2025-11-08 16:20:27.264874
399	5	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-10 05:39:27.264874
639	24	Requested	Intermediate	2	Daily	Seeded assignment	2025-11-29 11:13:27.264874
868	22	Approved	\N	9	\N	Seeded request	2025-11-03 12:21:27.264874
2	12	Requested	\N	\N	\N	Seeded assignment	\N
796	12	Requested	\N	4	Weekly	Seeded request	\N
299	21	Approved	Beginner	\N	Rarely	Seeded assignment	\N
536	9	Approved	Advanced	10	Monthly	Seeded assignment	\N
566	3	Approved	\N	4	\N	Seeded assignment	2025-12-02 10:57:27.264874
533	18	Requested	Expert	\N	Rarely	Seeded assignment	\N
495	7	Approved	\N	5	Monthly	Seeded assignment	\N
858	23	Requested	\N	\N	Weekly	Seeded request	2025-11-28 12:30:27.264874
176	8	Approved	\N	6	Monthly	Seeded assignment	2025-12-02 22:50:27.264874
918	11	Requested	\N	10	\N	Seeded request	\N
516	10	Requested	Advanced	\N	\N	Seeded request	\N
502	17	Approved	\N	10	Rarely	Seeded request	\N
832	6	Approved	Beginner	6	Monthly	Seeded assignment	2025-11-22 20:07:27.264874
713	10	Requested	Beginner	3	Daily	Seeded assignment	\N
807	5	Approved	Intermediate	10	Monthly	Seeded assignment	2025-11-14 07:18:27.264874
41	10	Approved	Expert	0	\N	Seeded assignment	\N
182	22	Approved	Beginner	4	\N	Seeded assignment	\N
769	10	Requested	Advanced	6	Rarely	Seeded request	\N
732	21	Approved	\N	8	Daily	Seeded request	\N
88	6	Approved	Expert	7	Rarely	Seeded assignment	\N
123	4	Requested	\N	\N	\N	Seeded request	\N
693	21	Requested	\N	\N	Weekly	Seeded assignment	\N
798	6	Requested	Advanced	\N	Monthly	Seeded assignment	2025-11-17 18:24:27.264874
874	6	Requested	Expert	\N	Weekly	Seeded assignment	\N
841	1	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-18 07:03:27.264874
10	18	Requested	Advanced	\N	Monthly	Seeded request	\N
346	1	Requested	Beginner	2	Daily	Seeded assignment	\N
591	10	Approved	\N	\N	Weekly	Seeded assignment	\N
817	20	Approved	\N	0	Monthly	Seeded request	\N
23	23	Approved	Intermediate	10	\N	Seeded request	\N
610	3	Approved	\N	\N	Monthly	Seeded assignment	2025-11-23 10:41:27.264874
763	18	Approved	\N	4	\N	Seeded assignment	2025-11-22 21:50:27.264874
521	10	Requested	Advanced	0	Daily	Seeded assignment	\N
665	5	Requested	\N	9	Weekly	Seeded assignment	\N
590	4	Approved	\N	\N	Daily	Seeded assignment	\N
696	22	Approved	Expert	7	Weekly	Seeded assignment	2025-11-10 07:33:27.264874
779	20	Approved	Beginner	4	Rarely	Seeded assignment	\N
972	6	Approved	Expert	\N	Weekly	Seeded assignment	\N
752	18	Requested	Expert	5	\N	Seeded request	\N
951	25	Approved	\N	\N	Weekly	Seeded request	2025-11-18 12:56:27.264874
848	12	Requested	\N	2	\N	Seeded assignment	\N
698	17	Approved	\N	4	\N	Seeded assignment	2025-11-20 16:13:27.264874
125	16	Approved	Advanced	8	\N	Seeded assignment	\N
381	12	Approved	\N	\N	Daily	Seeded request	\N
844	25	Approved	Intermediate	7	Weekly	Seeded request	2025-12-02 11:52:27.264874
729	16	Requested	\N	5	\N	Seeded assignment	\N
911	8	Requested	Intermediate	\N	Weekly	Seeded assignment	\N
304	4	Requested	Beginner	3	Rarely	Seeded assignment	2025-11-24 02:50:27.264874
444	1	Approved	\N	5	Monthly	Seeded assignment	2025-11-25 04:34:27.264874
594	12	Requested	Expert	6	\N	Seeded assignment	\N
98	18	Requested	Beginner	4	\N	Seeded assignment	2025-11-23 05:39:27.264874
181	3	Approved	\N	9	Daily	Seeded request	\N
827	20	Approved	Advanced	2	Monthly	Seeded request	2025-11-29 06:29:27.264874
412	1	Approved	Intermediate	7	Rarely	Seeded assignment	\N
290	7	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-15 01:26:27.264874
520	25	Approved	Expert	\N	Monthly	Seeded request	\N
688	25	Approved	\N	\N	Weekly	Seeded request	\N
66	20	Approved	Expert	9	\N	Seeded request	\N
89	20	Requested	Beginner	5	Weekly	Seeded request	2025-11-25 06:22:27.264874
640	20	Requested	Advanced	0	\N	Seeded request	2025-11-22 15:57:27.264874
248	17	Approved	Intermediate	9	\N	Seeded assignment	\N
250	12	Approved	Intermediate	7	Rarely	Seeded request	2025-11-08 16:01:27.264874
929	7	Approved	\N	9	Monthly	Seeded assignment	\N
940	24	Requested	\N	8	\N	Seeded request	2025-11-17 10:53:27.264874
255	20	Requested	\N	9	\N	Seeded request	\N
753	6	Requested	Beginner	\N	Daily	Seeded request	2025-11-19 08:17:27.264874
794	10	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-09 06:21:27.264874
532	22	Approved	Advanced	\N	\N	Seeded request	\N
578	4	Approved	\N	\N	Weekly	Seeded assignment	\N
606	19	Approved	\N	10	\N	Seeded assignment	\N
642	1	Approved	Intermediate	7	Weekly	Seeded assignment	2025-11-24 09:00:27.264874
474	9	Requested	Advanced	7	Rarely	Seeded request	\N
856	19	Approved	Beginner	9	\N	Seeded assignment	2025-11-27 11:13:27.264874
468	16	Requested	\N	0	\N	Seeded assignment	2025-11-16 17:49:27.264874
543	1	Approved	Intermediate	\N	\N	Seeded assignment	2025-12-01 21:07:27.264874
799	21	Requested	Beginner	2	Daily	Seeded request	2025-11-05 07:29:27.264874
851	9	Requested	Advanced	\N	Monthly	Seeded request	\N
705	3	Approved	\N	\N	\N	Seeded request	\N
733	5	Approved	Beginner	\N	Rarely	Seeded request	\N
157	6	Requested	\N	1	Rarely	Seeded assignment	\N
306	8	Requested	Intermediate	0	Rarely	Seeded assignment	\N
139	20	Requested	\N	4	Monthly	Seeded request	\N
614	20	Requested	\N	4	Monthly	Seeded assignment	\N
508	11	Requested	Advanced	6	\N	Seeded assignment	\N
246	25	Approved	\N	\N	Weekly	Seeded assignment	2025-11-07 00:29:27.264874
973	10	Requested	Intermediate	5	Monthly	Seeded assignment	2025-11-12 18:38:27.264874
952	16	Approved	Intermediate	3	Rarely	Seeded request	2025-11-29 14:24:27.264874
633	18	Requested	Advanced	1	Daily	Seeded assignment	\N
706	13	Approved	\N	7	Weekly	Seeded assignment	2025-11-10 12:10:27.264874
354	25	Approved	Expert	\N	Rarely	Seeded assignment	\N
900	18	Approved	\N	4	Monthly	Seeded request	\N
267	25	Requested	Intermediate	10	\N	Seeded assignment	2025-11-06 01:19:27.264874
290	23	Approved	Intermediate	0	\N	Seeded request	2025-11-21 21:25:27.264874
813	3	Approved	Intermediate	4	Weekly	Seeded assignment	\N
420	8	Approved	Advanced	3	\N	Seeded request	2025-11-13 20:43:27.264874
976	22	Approved	\N	6	Monthly	Seeded assignment	2025-11-20 23:36:27.264874
249	17	Requested	Intermediate	10	\N	Seeded request	\N
929	23	Requested	\N	8	Monthly	Seeded assignment	\N
36	7	Approved	\N	8	\N	Seeded assignment	2025-11-29 14:24:27.264874
152	1	Requested	\N	8	\N	Seeded assignment	\N
723	16	Approved	Intermediate	\N	Monthly	Seeded request	2025-11-05 09:01:27.264874
505	20	Requested	\N	10	\N	Seeded request	\N
857	7	Approved	Expert	\N	\N	Seeded assignment	2025-11-27 20:20:27.264874
817	12	Requested	\N	\N	\N	Seeded request	\N
960	23	Approved	Beginner	\N	Daily	Seeded assignment	\N
62	24	Approved	\N	7	Monthly	Seeded request	\N
802	19	Approved	\N	\N	\N	Seeded request	2025-11-12 20:46:27.264874
819	3	Requested	Advanced	1	Monthly	Seeded request	2025-11-03 13:29:27.264874
194	17	Approved	Expert	5	Daily	Seeded assignment	2025-11-23 05:15:27.264874
5	1	Requested	Intermediate	\N	\N	Seeded request	\N
938	9	Requested	\N	\N	Rarely	Seeded assignment	\N
61	6	Requested	Advanced	\N	\N	Seeded request	\N
513	17	Approved	Advanced	5	\N	Seeded assignment	\N
459	9	Approved	Advanced	\N	Daily	Seeded request	\N
810	7	Approved	Beginner	0	Weekly	Seeded request	\N
425	23	Requested	Advanced	10	Rarely	Seeded assignment	2025-11-12 07:50:27.264874
901	6	Requested	Advanced	1	Rarely	Seeded request	\N
554	12	Requested	Intermediate	5	Daily	Seeded request	2025-11-18 04:22:27.264874
471	11	Approved	\N	\N	\N	Seeded assignment	\N
749	8	Approved	\N	\N	\N	Seeded assignment	2025-12-02 00:21:27.264874
287	4	Approved	\N	10	Daily	Seeded assignment	2025-11-09 19:40:27.264874
26	13	Approved	Intermediate	4	\N	Seeded request	2025-11-28 14:36:27.264874
130	8	Approved	\N	0	Daily	Seeded request	\N
72	20	Approved	Beginner	3	Rarely	Seeded request	\N
512	11	Requested	\N	9	\N	Seeded assignment	\N
39	12	Approved	Advanced	\N	Monthly	Seeded request	\N
529	17	Approved	Intermediate	\N	Daily	Seeded request	\N
346	9	Requested	Expert	5	\N	Seeded assignment	\N
921	19	Approved	\N	8	Daily	Seeded assignment	2025-11-29 05:40:27.264874
212	8	Approved	\N	7	\N	Seeded assignment	\N
253	19	Requested	Beginner	\N	\N	Seeded request	\N
151	19	Approved	Beginner	0	\N	Seeded assignment	\N
777	20	Approved	Beginner	0	Rarely	Seeded request	\N
582	20	Approved	Expert	3	Rarely	Seeded assignment	\N
662	12	Approved	Expert	9	\N	Seeded request	\N
737	4	Approved	Intermediate	0	\N	Seeded assignment	2025-11-19 23:53:27.264874
165	16	Requested	Beginner	7	Monthly	Seeded assignment	2025-11-21 21:04:27.264874
412	9	Requested	Intermediate	2	\N	Seeded assignment	2025-12-02 10:17:27.264874
788	10	Approved	Intermediate	6	\N	Seeded request	\N
742	10	Approved	Expert	4	\N	Seeded request	2025-11-30 05:44:27.264874
782	4	Requested	Advanced	2	Monthly	Seeded assignment	\N
610	4	Approved	\N	0	Monthly	Seeded request	\N
401	16	Approved	\N	3	Monthly	Seeded assignment	\N
570	16	Requested	\N	\N	Daily	Seeded assignment	\N
239	11	Requested	\N	1	Rarely	Seeded request	\N
227	7	Requested	\N	\N	\N	Seeded assignment	2025-11-25 21:01:27.264874
31	11	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
123	3	Requested	Intermediate	2	Monthly	Seeded assignment	2025-11-30 00:29:27.264874
756	19	Requested	Advanced	6	Weekly	Seeded request	\N
444	9	Approved	\N	\N	Daily	Seeded assignment	\N
641	6	Requested	Advanced	3	\N	Seeded assignment	2025-11-27 19:50:27.264874
653	13	Requested	\N	4	Monthly	Seeded request	\N
205	6	Approved	Intermediate	\N	Rarely	Seeded request	2025-12-01 05:40:27.264874
830	7	Requested	Beginner	\N	Weekly	Seeded request	2025-12-02 13:44:27.264874
89	22	Approved	Advanced	3	Weekly	Seeded assignment	\N
283	24	Requested	\N	5	Daily	Seeded request	\N
24	19	Requested	\N	\N	\N	Seeded request	2025-11-15 02:31:27.264874
608	17	Requested	Intermediate	10	Weekly	Seeded assignment	\N
750	6	Requested	Expert	0	\N	Seeded assignment	2025-12-02 06:00:27.264874
827	22	Requested	Expert	5	Rarely	Seeded assignment	\N
80	8	Approved	\N	\N	Monthly	Seeded request	\N
336	23	Requested	Beginner	9	Daily	Seeded request	\N
763	3	Approved	\N	5	\N	Seeded assignment	2025-12-02 04:12:27.264874
507	11	Approved	\N	\N	Daily	Seeded assignment	\N
540	12	Approved	\N	9	Weekly	Seeded assignment	2025-12-01 03:54:27.264874
29	7	Requested	\N	6	Weekly	Seeded request	2025-11-21 18:31:27.264874
252	16	Approved	\N	7	Rarely	Seeded assignment	\N
596	11	Approved	Beginner	4	Monthly	Seeded request	2025-11-10 22:27:27.264874
426	20	Requested	Intermediate	10	\N	Seeded request	\N
563	1	Requested	Beginner	7	Rarely	Seeded assignment	\N
512	1	Requested	\N	1	\N	Seeded assignment	\N
258	5	Requested	\N	9	\N	Seeded assignment	\N
428	3	Requested	\N	10	Monthly	Seeded request	\N
389	6	Approved	\N	\N	\N	Seeded assignment	2025-11-21 15:18:27.264874
758	19	Approved	Advanced	4	Weekly	Seeded assignment	\N
584	21	Requested	Beginner	\N	Monthly	Seeded assignment	2025-11-25 20:22:27.264874
767	6	Approved	\N	\N	Daily	Seeded assignment	\N
318	8	Approved	Beginner	\N	\N	Seeded assignment	2025-11-13 01:33:27.264874
978	17	Approved	\N	\N	\N	Seeded assignment	\N
759	5	Approved	Advanced	8	Rarely	Seeded request	\N
843	9	Approved	Advanced	10	Monthly	Seeded request	2025-11-09 17:26:27.264874
131	16	Requested	\N	\N	Monthly	Seeded request	2025-11-24 23:00:27.264874
470	8	Approved	\N	4	\N	Seeded assignment	2025-11-21 19:33:27.264874
615	24	Approved	Advanced	\N	Monthly	Seeded assignment	2025-11-23 09:46:27.264874
986	6	Requested	Advanced	6	Rarely	Seeded request	2025-11-05 11:30:27.264874
738	22	Approved	\N	5	Monthly	Seeded assignment	2025-11-12 20:55:27.264874
234	9	Requested	\N	8	Weekly	Seeded request	2025-11-30 15:47:27.264874
672	3	Requested	Expert	7	Weekly	Seeded request	2025-11-14 23:10:27.264874
948	25	Requested	Expert	1	\N	Seeded assignment	\N
341	6	Approved	Beginner	\N	Daily	Seeded request	\N
85	19	Approved	Beginner	\N	\N	Seeded assignment	2025-11-17 06:14:27.264874
643	13	Requested	\N	\N	Weekly	Seeded assignment	\N
371	25	Requested	\N	1	Rarely	Seeded assignment	2025-11-27 22:26:27.264874
632	6	Approved	Expert	7	\N	Seeded request	\N
107	5	Approved	\N	2	\N	Seeded request	2025-11-26 19:31:27.264874
820	5	Approved	Expert	9	Rarely	Seeded assignment	2025-11-10 01:37:27.264874
286	6	Approved	Expert	\N	\N	Seeded request	2025-11-25 04:51:27.264874
99	8	Requested	Expert	6	Monthly	Seeded request	\N
334	23	Approved	\N	10	\N	Seeded request	\N
609	13	Approved	Advanced	\N	Monthly	Seeded assignment	\N
770	11	Requested	Beginner	3	Rarely	Seeded assignment	\N
868	20	Approved	Intermediate	5	\N	Seeded assignment	\N
39	22	Approved	\N	0	Daily	Seeded assignment	\N
544	10	Requested	\N	1	Daily	Seeded assignment	\N
805	1	Approved	\N	\N	\N	Seeded request	2025-11-18 17:31:27.264874
135	22	Requested	Advanced	0	Monthly	Seeded assignment	\N
814	10	Approved	Advanced	0	\N	Seeded request	\N
332	20	Requested	\N	\N	Rarely	Seeded assignment	2025-11-20 02:45:27.264874
325	16	Requested	Beginner	\N	\N	Seeded request	\N
484	12	Approved	\N	1	Rarely	Seeded request	2025-11-06 08:22:27.264874
958	16	Approved	\N	\N	Weekly	Seeded assignment	2025-11-21 04:17:27.264874
362	8	Requested	Beginner	10	\N	Seeded assignment	2025-11-24 16:02:27.264874
880	18	Requested	Intermediate	\N	\N	Seeded assignment	\N
241	16	Approved	\N	\N	\N	Seeded assignment	2025-11-28 10:09:27.264874
406	23	Requested	Intermediate	1	Monthly	Seeded assignment	2025-11-24 16:12:27.264874
348	20	Requested	\N	7	\N	Seeded assignment	\N
12	9	Approved	Beginner	\N	Monthly	Seeded assignment	\N
619	10	Requested	Expert	\N	\N	Seeded assignment	\N
3	21	Approved	Expert	0	\N	Seeded request	\N
915	18	Approved	Beginner	\N	Daily	Seeded request	\N
845	23	Requested	Expert	9	Monthly	Seeded assignment	2025-11-25 13:15:27.264874
956	3	Approved	Intermediate	10	Monthly	Seeded request	2025-11-29 06:02:27.264874
510	17	Requested	Beginner	\N	Daily	Seeded assignment	\N
62	8	Approved	\N	6	\N	Seeded request	2025-11-21 13:03:27.264874
111	10	Requested	\N	\N	\N	Seeded request	2025-12-02 05:55:27.264874
514	8	Approved	Intermediate	7	\N	Seeded assignment	2025-11-28 12:35:27.264874
206	10	Approved	Beginner	\N	\N	Seeded request	2025-11-20 03:59:27.264874
109	16	Requested	Intermediate	\N	Weekly	Seeded assignment	\N
834	1	Approved	Beginner	\N	\N	Seeded request	\N
917	24	Requested	\N	7	\N	Seeded assignment	\N
882	1	Requested	\N	\N	Daily	Seeded assignment	2025-11-15 01:01:27.264874
694	13	Requested	\N	\N	Rarely	Seeded request	2025-11-26 20:58:27.264874
237	10	Approved	Intermediate	3	Rarely	Seeded assignment	2025-11-24 03:48:27.264874
812	4	Requested	Expert	\N	Daily	Seeded request	\N
829	17	Approved	\N	2	Rarely	Seeded request	\N
5	11	Approved	Intermediate	7	Daily	Seeded assignment	\N
500	12	Requested	Beginner	\N	Weekly	Seeded assignment	2025-11-12 12:14:27.264874
462	11	Approved	Advanced	\N	\N	Seeded request	\N
33	4	Requested	Expert	\N	Daily	Seeded assignment	2025-11-05 18:04:27.264874
408	9	Requested	\N	6	Weekly	Seeded assignment	\N
343	3	Approved	\N	\N	Weekly	Seeded request	\N
219	7	Approved	\N	3	Daily	Seeded assignment	\N
360	10	Requested	Beginner	2	Rarely	Seeded assignment	\N
678	25	Requested	\N	1	\N	Seeded request	\N
536	11	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
552	7	Requested	\N	\N	\N	Seeded assignment	2025-11-19 17:45:27.264874
46	20	Approved	Advanced	3	\N	Seeded request	2025-11-27 23:36:27.264874
718	13	Approved	Beginner	6	Monthly	Seeded assignment	\N
46	12	Approved	\N	\N	Monthly	Seeded assignment	\N
45	25	Approved	\N	4	Weekly	Seeded assignment	\N
512	9	Requested	Beginner	10	\N	Seeded request	\N
282	16	Approved	Beginner	3	\N	Seeded assignment	\N
284	9	Requested	Advanced	\N	\N	Seeded request	2025-11-16 09:51:27.264874
714	3	Approved	\N	5	\N	Seeded assignment	2025-11-26 08:25:27.264874
98	4	Requested	Expert	6	Rarely	Seeded assignment	2025-11-27 04:28:27.264874
226	20	Requested	\N	\N	Weekly	Seeded assignment	2025-11-12 16:24:27.264874
174	10	Approved	Intermediate	5	Daily	Seeded assignment	\N
76	7	Approved	Expert	3	\N	Seeded assignment	\N
777	22	Approved	Intermediate	\N	Daily	Seeded assignment	2025-11-27 21:09:27.264874
854	17	Approved	Expert	\N	Weekly	Seeded request	\N
236	17	Approved	Expert	1	\N	Seeded assignment	\N
623	6	Requested	Expert	10	Daily	Seeded assignment	2025-11-24 19:40:27.264874
112	19	Approved	\N	3	\N	Seeded assignment	2025-12-01 19:21:27.264874
674	4	Requested	Advanced	\N	Monthly	Seeded assignment	\N
73	12	Approved	Advanced	10	Rarely	Seeded assignment	\N
828	6	Approved	Beginner	4	Rarely	Seeded request	2025-11-30 04:58:27.264874
233	20	Requested	Advanced	\N	Weekly	Seeded assignment	\N
671	25	Approved	Expert	2	Monthly	Seeded request	\N
774	3	Requested	Intermediate	6	Weekly	Seeded assignment	2025-11-11 13:02:27.264874
271	23	Requested	Intermediate	4	Rarely	Seeded assignment	\N
686	4	Approved	Beginner	2	Rarely	Seeded request	\N
983	19	Approved	Intermediate	7	Rarely	Seeded request	\N
946	18	Requested	\N	2	Rarely	Seeded request	2025-11-10 20:14:27.264874
10	4	Requested	Intermediate	1	Weekly	Seeded request	\N
40	12	Approved	\N	7	\N	Seeded assignment	\N
182	12	Approved	\N	\N	Daily	Seeded assignment	\N
92	10	Approved	\N	\N	Weekly	Seeded request	2025-11-26 02:21:27.264874
450	23	Approved	Beginner	\N	Rarely	Seeded request	\N
274	11	Approved	\N	6	\N	Seeded assignment	\N
277	12	Approved	Expert	\N	Rarely	Seeded request	2025-11-13 09:44:27.264874
763	4	Requested	Intermediate	1	\N	Seeded assignment	\N
31	9	Approved	Expert	10	\N	Seeded request	\N
261	12	Requested	Intermediate	6	Monthly	Seeded request	\N
273	23	Requested	Advanced	\N	Weekly	Seeded request	\N
348	12	Requested	\N	0	Monthly	Seeded assignment	\N
469	25	Approved	\N	\N	\N	Seeded assignment	2025-11-25 08:08:27.264874
908	21	Approved	\N	8	Weekly	Seeded assignment	2025-11-20 06:08:27.264874
553	8	Requested	\N	\N	\N	Seeded assignment	\N
72	22	Approved	Intermediate	7	Rarely	Seeded assignment	2025-11-25 21:43:27.264874
442	9	Approved	\N	\N	Weekly	Seeded request	\N
48	6	Approved	\N	5	Weekly	Seeded request	\N
79	23	Approved	Intermediate	7	\N	Seeded request	\N
464	7	Approved	\N	1	\N	Seeded request	2025-11-29 15:16:27.264874
16	17	Approved	Intermediate	8	Daily	Seeded assignment	\N
716	24	Requested	Beginner	4	\N	Seeded request	2025-11-13 15:51:27.264874
102	22	Requested	Expert	\N	Weekly	Seeded request	2025-11-29 17:37:27.264874
911	24	Requested	Beginner	\N	\N	Seeded assignment	2025-11-13 15:26:27.264874
898	22	Requested	Advanced	\N	Daily	Seeded request	\N
245	25	Approved	Intermediate	\N	\N	Seeded request	\N
526	3	Requested	Advanced	5	Daily	Seeded assignment	2025-11-28 01:05:27.264874
730	20	Approved	Intermediate	1	Rarely	Seeded assignment	\N
848	22	Requested	Intermediate	\N	\N	Seeded request	\N
143	22	Approved	\N	7	Daily	Seeded assignment	\N
366	19	Approved	Expert	6	\N	Seeded assignment	2025-11-26 05:57:27.264874
343	4	Approved	\N	\N	Rarely	Seeded request	2025-11-08 10:38:27.264874
677	25	Approved	Advanced	\N	Monthly	Seeded request	2025-11-04 00:13:27.264874
461	20	Requested	Beginner	3	Weekly	Seeded assignment	\N
614	22	Approved	\N	3	Monthly	Seeded assignment	2025-11-06 05:00:27.264874
613	17	Requested	Beginner	\N	Monthly	Seeded request	\N
166	24	Requested	Expert	4	\N	Seeded assignment	2025-11-11 15:28:27.264874
724	7	Approved	\N	\N	Rarely	Seeded request	2025-11-03 08:14:27.264874
247	10	Requested	Beginner	8	\N	Seeded assignment	2025-12-01 11:36:27.264874
337	18	Requested	\N	9	Weekly	Seeded assignment	\N
504	3	Approved	Advanced	2	Rarely	Seeded assignment	\N
478	16	Requested	\N	\N	Monthly	Seeded request	\N
666	25	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
369	7	Requested	\N	\N	Rarely	Seeded assignment	\N
440	19	Approved	Advanced	\N	\N	Seeded request	2025-11-10 17:16:27.264874
295	9	Requested	Beginner	4	Daily	Seeded request	\N
830	23	Requested	Expert	4	Daily	Seeded request	\N
358	13	Requested	Beginner	0	Weekly	Seeded assignment	\N
855	6	Approved	Intermediate	4	Monthly	Seeded request	\N
413	16	Approved	\N	1	\N	Seeded assignment	\N
571	6	Requested	Beginner	2	\N	Seeded assignment	\N
936	17	Approved	Expert	\N	Rarely	Seeded request	2025-12-01 09:07:27.264874
949	22	Requested	Beginner	\N	Daily	Seeded request	2025-11-08 15:14:27.264874
474	11	Approved	Advanced	\N	Rarely	Seeded assignment	\N
589	19	Requested	\N	5	\N	Seeded assignment	\N
150	21	Approved	\N	\N	\N	Seeded assignment	\N
34	22	Requested	\N	\N	Monthly	Seeded request	\N
297	18	Approved	\N	1	\N	Seeded request	\N
682	25	Approved	Expert	3	Rarely	Seeded request	2025-11-04 08:12:27.264874
145	4	Approved	Expert	1	Rarely	Seeded assignment	\N
365	20	Requested	Intermediate	9	Weekly	Seeded assignment	\N
819	18	Requested	\N	7	\N	Seeded assignment	2025-11-23 20:48:27.264874
400	18	Requested	Intermediate	6	Daily	Seeded assignment	2025-11-14 04:03:27.264874
540	20	Approved	Intermediate	10	\N	Seeded request	\N
164	5	Requested	Advanced	5	Rarely	Seeded assignment	\N
473	18	Approved	Intermediate	4	Rarely	Seeded assignment	\N
208	10	Requested	Expert	\N	\N	Seeded request	\N
813	18	Requested	Intermediate	2	\N	Seeded assignment	2025-11-22 16:26:27.264874
387	23	Requested	\N	2	\N	Seeded request	2025-11-25 08:02:27.264874
163	4	Approved	Intermediate	4	Monthly	Seeded assignment	\N
104	4	Approved	Advanced	\N	Monthly	Seeded assignment	\N
173	21	Requested	Expert	\N	Daily	Seeded assignment	\N
257	17	Requested	\N	10	Weekly	Seeded request	\N
319	19	Approved	Advanced	\N	Weekly	Seeded assignment	\N
927	22	Approved	\N	\N	\N	Seeded assignment	\N
607	23	Approved	Intermediate	2	Daily	Seeded assignment	\N
707	6	Requested	\N	10	\N	Seeded assignment	\N
235	23	Approved	Beginner	\N	Daily	Seeded request	\N
639	8	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
792	21	Approved	Beginner	\N	\N	Seeded request	2025-11-03 22:28:27.264874
455	4	Approved	Advanced	9	\N	Seeded assignment	\N
566	19	Approved	\N	5	\N	Seeded request	2025-11-06 15:44:27.264874
942	9	Requested	\N	1	\N	Seeded request	\N
96	20	Approved	Advanced	9	\N	Seeded assignment	2025-11-23 14:56:27.264874
650	21	Requested	\N	\N	Daily	Seeded assignment	\N
140	13	Approved	Beginner	\N	\N	Seeded assignment	\N
883	9	Approved	\N	4	\N	Seeded assignment	\N
583	21	Requested	Expert	6	\N	Seeded assignment	\N
97	7	Approved	\N	2	Rarely	Seeded request	\N
801	4	Approved	Intermediate	\N	\N	Seeded assignment	2025-11-24 00:56:27.264874
856	4	Approved	\N	\N	Rarely	Seeded assignment	2025-11-11 00:32:27.264874
547	19	Approved	\N	\N	Rarely	Seeded request	\N
261	5	Requested	Expert	5	\N	Seeded assignment	\N
126	8	Approved	Intermediate	4	Monthly	Seeded assignment	\N
159	6	Approved	Advanced	0	\N	Seeded request	2025-11-05 12:45:27.264874
511	8	Approved	Expert	5	\N	Seeded request	2025-11-29 14:38:27.264874
326	11	Requested	Advanced	8	Daily	Seeded request	\N
578	19	Approved	\N	8	Daily	Seeded request	2025-11-29 21:20:27.264874
772	10	Requested	Intermediate	7	Weekly	Seeded assignment	2025-11-15 05:07:27.264874
850	4	Approved	Intermediate	10	\N	Seeded assignment	\N
838	9	Approved	Advanced	0	\N	Seeded request	\N
415	24	Requested	Intermediate	6	\N	Seeded request	2025-11-29 10:06:27.264874
968	8	Requested	Beginner	\N	\N	Seeded request	2025-11-15 23:05:27.264874
73	5	Requested	Expert	\N	Weekly	Seeded request	\N
218	3	Approved	Expert	6	\N	Seeded assignment	\N
212	10	Approved	\N	8	\N	Seeded assignment	2025-11-17 00:16:27.264874
173	17	Approved	Intermediate	3	Daily	Seeded assignment	2025-11-10 14:45:27.264874
256	18	Approved	Intermediate	\N	Weekly	Seeded assignment	\N
434	7	Requested	Advanced	\N	Monthly	Seeded request	2025-11-25 17:22:27.264874
492	11	Requested	Advanced	\N	\N	Seeded request	2025-11-12 15:32:27.264874
561	24	Approved	\N	0	\N	Seeded assignment	2025-11-28 22:44:27.264874
378	8	Requested	Intermediate	7	Rarely	Seeded request	2025-11-19 18:28:27.264874
214	1	Requested	\N	4	\N	Seeded assignment	2025-11-27 12:21:27.264874
75	24	Approved	\N	8	Daily	Seeded request	\N
792	17	Requested	\N	\N	Rarely	Seeded request	\N
722	12	Requested	Expert	6	Rarely	Seeded assignment	2025-11-24 06:36:27.264874
496	16	Approved	Advanced	3	Daily	Seeded assignment	2025-11-08 03:13:27.264874
784	17	Requested	Advanced	\N	Daily	Seeded request	\N
294	21	Approved	Advanced	\N	Rarely	Seeded assignment	2025-11-19 15:36:27.264874
382	9	Approved	\N	\N	Daily	Seeded assignment	2025-11-15 01:56:27.264874
953	10	Requested	Expert	6	Monthly	Seeded assignment	\N
483	23	Requested	Beginner	\N	\N	Seeded assignment	\N
668	24	Approved	Intermediate	\N	Monthly	Seeded assignment	\N
599	16	Requested	Beginner	\N	Monthly	Seeded assignment	\N
503	25	Approved	\N	6	Daily	Seeded assignment	\N
314	13	Requested	Intermediate	7	Rarely	Seeded assignment	2025-11-16 03:18:27.264874
374	11	Approved	Expert	0	Rarely	Seeded assignment	2025-11-09 17:44:27.264874
148	21	Requested	\N	\N	Weekly	Seeded assignment	2025-11-16 17:37:27.264874
785	3	Approved	Beginner	\N	Weekly	Seeded assignment	2025-11-26 03:39:27.264874
106	1	Approved	Intermediate	7	\N	Seeded assignment	2025-11-24 05:12:27.264874
628	23	Approved	\N	\N	\N	Seeded assignment	\N
764	8	Approved	\N	\N	Daily	Seeded assignment	2025-12-01 18:48:27.264874
116	6	Approved	Intermediate	\N	\N	Seeded assignment	\N
448	10	Requested	Intermediate	1	Monthly	Seeded assignment	\N
601	1	Approved	\N	5	Daily	Seeded assignment	\N
181	19	Approved	Intermediate	\N	Rarely	Seeded request	\N
890	24	Approved	Expert	3	Weekly	Seeded request	2025-11-08 10:38:27.264874
55	11	Requested	Beginner	\N	\N	Seeded assignment	\N
426	5	Requested	\N	\N	\N	Seeded assignment	2025-11-22 19:44:27.264874
491	10	Approved	\N	\N	\N	Seeded request	\N
278	18	Requested	\N	\N	Rarely	Seeded request	\N
452	1	Requested	\N	1	\N	Seeded request	\N
38	11	Approved	Beginner	\N	\N	Seeded assignment	\N
544	24	Requested	Advanced	7	\N	Seeded request	2025-11-27 16:06:27.264874
339	4	Approved	Beginner	0	Monthly	Seeded assignment	2025-11-09 22:04:27.264874
969	3	Requested	Expert	\N	Daily	Seeded assignment	2025-11-22 02:26:27.264874
908	17	Approved	\N	10	Monthly	Seeded assignment	\N
345	10	Approved	Beginner	\N	Daily	Seeded assignment	\N
416	18	Approved	\N	\N	Monthly	Seeded request	\N
517	21	Requested	Intermediate	\N	Daily	Seeded assignment	2025-11-15 06:58:27.264874
585	23	Requested	\N	\N	Weekly	Seeded assignment	\N
638	12	Approved	Advanced	4	Weekly	Seeded request	\N
665	22	Requested	Intermediate	5	Weekly	Seeded assignment	2025-11-09 23:45:27.264874
353	11	Approved	Beginner	\N	Rarely	Seeded assignment	\N
420	10	Approved	\N	7	Weekly	Seeded request	\N
393	6	Requested	Beginner	4	Daily	Seeded assignment	\N
648	21	Requested	Advanced	5	Rarely	Seeded assignment	\N
81	6	Requested	Expert	\N	\N	Seeded request	\N
237	24	Requested	Advanced	\N	Weekly	Seeded assignment	\N
240	17	Requested	Advanced	8	Rarely	Seeded assignment	2025-11-12 14:22:27.264874
206	24	Approved	\N	7	Rarely	Seeded assignment	2025-11-10 16:34:27.264874
427	18	Requested	Expert	10	\N	Seeded assignment	\N
778	6	Approved	Intermediate	6	Daily	Seeded assignment	\N
151	4	Requested	Beginner	\N	Daily	Seeded assignment	\N
920	17	Requested	\N	7	Daily	Seeded assignment	\N
107	12	Approved	Advanced	\N	Daily	Seeded assignment	2025-11-25 09:19:27.264874
522	17	Requested	Beginner	6	Monthly	Seeded request	2025-11-30 17:26:27.264874
679	12	Approved	Beginner	\N	\N	Seeded assignment	2025-11-14 15:45:27.264874
359	16	Approved	\N	\N	\N	Seeded request	2025-11-22 23:27:27.264874
600	18	Requested	\N	\N	Rarely	Seeded assignment	2025-11-30 07:34:27.264874
460	6	Approved	Advanced	\N	\N	Seeded assignment	\N
700	9	Requested	Beginner	\N	Monthly	Seeded assignment	\N
832	25	Requested	Beginner	10	Daily	Seeded assignment	\N
976	5	Requested	Intermediate	7	\N	Seeded assignment	\N
147	10	Requested	Expert	6	Daily	Seeded request	2025-11-08 07:21:27.264874
897	5	Requested	Intermediate	3	Monthly	Seeded request	\N
531	7	Approved	Beginner	\N	\N	Seeded assignment	\N
883	1	Requested	\N	3	Monthly	Seeded request	2025-11-04 17:43:27.264874
400	19	Approved	\N	8	\N	Seeded request	2025-11-17 18:53:27.264874
576	12	Requested	\N	8	Monthly	Seeded assignment	\N
26	16	Requested	Beginner	\N	\N	Seeded assignment	\N
218	4	Approved	Expert	\N	\N	Seeded request	2025-11-25 00:01:27.264874
238	22	Requested	Beginner	\N	\N	Seeded request	\N
258	12	Requested	Beginner	2	\N	Seeded assignment	2025-11-04 04:49:27.264874
747	17	Requested	Advanced	5	Weekly	Seeded request	\N
850	3	Approved	\N	4	\N	Seeded assignment	2025-11-30 09:27:27.264874
281	13	Requested	\N	\N	Monthly	Seeded assignment	\N
625	11	Approved	Intermediate	\N	\N	Seeded request	2025-11-21 23:05:27.264874
606	3	Approved	Intermediate	7	Weekly	Seeded request	\N
185	23	Approved	\N	0	Rarely	Seeded request	2025-11-14 17:38:27.264874
301	13	Requested	Intermediate	4	\N	Seeded request	\N
382	1	Requested	\N	10	Weekly	Seeded request	\N
30	7	Requested	Intermediate	1	\N	Seeded request	\N
540	5	Approved	\N	6	Daily	Seeded assignment	2025-11-25 23:07:27.264874
19	12	Requested	Beginner	10	\N	Seeded assignment	2025-11-22 01:49:27.264874
398	12	Approved	\N	\N	\N	Seeded assignment	\N
528	24	Requested	Intermediate	8	Rarely	Seeded request	2025-11-28 13:06:27.264874
846	11	Approved	\N	\N	\N	Seeded assignment	2025-11-30 11:19:27.264874
743	21	Approved	\N	\N	\N	Seeded assignment	\N
616	25	Requested	\N	9	Rarely	Seeded assignment	2025-11-25 22:40:27.264874
28	7	Approved	\N	\N	Monthly	Seeded request	2025-11-19 13:42:27.264874
209	3	Approved	Advanced	\N	Rarely	Seeded assignment	\N
395	6	Approved	Advanced	7	Weekly	Seeded request	2025-11-18 17:44:27.264874
838	1	Approved	Beginner	2	Daily	Seeded assignment	2025-11-15 21:15:27.264874
213	4	Approved	\N	0	Daily	Seeded request	\N
886	19	Approved	Beginner	6	\N	Seeded assignment	2025-11-09 11:33:27.264874
761	6	Approved	Intermediate	10	Rarely	Seeded assignment	\N
829	21	Approved	Intermediate	0	\N	Seeded assignment	\N
630	3	Requested	\N	\N	Rarely	Seeded request	\N
265	22	Requested	Advanced	4	Monthly	Seeded assignment	2025-11-26 14:29:27.264874
367	18	Requested	Beginner	\N	Daily	Seeded assignment	2025-11-21 09:00:27.264874
500	5	Approved	Intermediate	7	Monthly	Seeded assignment	2025-11-27 20:39:27.264874
766	24	Requested	Beginner	2	Rarely	Seeded assignment	2025-11-08 08:41:27.264874
818	11	Requested	\N	3	\N	Seeded assignment	2025-11-13 17:43:27.264874
712	13	Approved	Advanced	4	Monthly	Seeded assignment	\N
498	12	Approved	Expert	8	\N	Seeded assignment	\N
753	25	Approved	\N	\N	\N	Seeded assignment	2025-11-19 18:24:27.264874
584	17	Approved	Expert	2	Daily	Seeded assignment	2025-11-19 04:19:27.264874
392	12	Requested	Beginner	\N	\N	Seeded assignment	\N
601	9	Requested	Intermediate	\N	\N	Seeded assignment	2025-11-17 15:04:27.264874
137	1	Requested	\N	6	Daily	Seeded assignment	2025-11-14 11:06:27.264874
579	19	Approved	\N	\N	\N	Seeded request	\N
866	9	Approved	\N	\N	Monthly	Seeded request	\N
899	16	Requested	Expert	8	Weekly	Seeded request	\N
685	7	Approved	\N	\N	\N	Seeded assignment	2025-11-12 03:10:27.264874
285	9	Approved	Beginner	10	\N	Seeded request	\N
414	16	Requested	\N	8	\N	Seeded assignment	\N
106	9	Requested	\N	\N	Daily	Seeded request	2025-11-29 18:33:27.264874
842	23	Approved	\N	\N	\N	Seeded request	2025-12-02 20:20:27.264874
468	13	Approved	Intermediate	6	Monthly	Seeded assignment	\N
983	18	Approved	Beginner	3	Weekly	Seeded assignment	\N
339	3	Approved	Intermediate	\N	Weekly	Seeded request	2025-11-12 10:07:27.264874
969	4	Requested	\N	3	Daily	Seeded assignment	\N
6	8	Approved	Expert	0	\N	Seeded assignment	2025-11-05 01:27:27.264874
879	13	Approved	Intermediate	10	Weekly	Seeded assignment	\N
215	11	Requested	Expert	8	\N	Seeded assignment	\N
587	23	Approved	Intermediate	0	Rarely	Seeded assignment	\N
746	10	Requested	\N	7	Weekly	Seeded assignment	\N
806	19	Requested	Intermediate	5	\N	Seeded assignment	2025-11-29 10:37:27.264874
673	12	Requested	\N	3	\N	Seeded assignment	2025-11-26 18:51:27.264874
808	25	Approved	Advanced	1	Daily	Seeded assignment	2025-11-06 13:08:27.264874
115	24	Approved	\N	1	\N	Seeded request	\N
446	23	Approved	\N	\N	Weekly	Seeded request	2025-11-19 11:42:27.264874
155	23	Approved	\N	\N	\N	Seeded request	2025-11-19 19:22:27.264874
541	16	Approved	Expert	9	\N	Seeded request	\N
874	25	Approved	Beginner	7	\N	Seeded assignment	\N
331	25	Requested	Beginner	2	Daily	Seeded assignment	\N
663	24	Approved	Advanced	7	Rarely	Seeded request	\N
831	23	Approved	Advanced	9	\N	Seeded assignment	\N
96	12	Approved	\N	\N	Weekly	Seeded assignment	\N
41	8	Approved	\N	4	Weekly	Seeded assignment	2025-11-12 11:25:27.264874
244	20	Requested	Beginner	5	Monthly	Seeded request	\N
977	13	Requested	\N	\N	Rarely	Seeded assignment	2025-11-12 18:27:27.264874
564	8	Approved	Intermediate	1	\N	Seeded assignment	\N
659	17	Requested	\N	5	\N	Seeded request	2025-11-13 04:13:27.264874
952	13	Requested	Intermediate	\N	Rarely	Seeded assignment	2025-11-21 12:31:27.264874
379	22	Requested	Beginner	\N	Weekly	Seeded request	\N
317	11	Requested	\N	10	\N	Seeded assignment	2025-12-02 11:11:27.264874
720	8	Requested	Intermediate	10	\N	Seeded assignment	\N
635	11	Requested	\N	1	\N	Seeded assignment	2025-12-01 05:52:27.264874
769	8	Approved	Advanced	9	Weekly	Seeded request	\N
\.


--
-- TOC entry 5119 (class 0 OID 16822)
-- Dependencies: 225
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project (project_id, project_name, status, project_owning_organization_id, project_start_date, project_end_date) FROM stdin;
1	Order Management	Approved	1	2025-01-01	2025-12-31
2	Offer Management	Approved	1	2025-04-15	2025-06-30
3	Customer A1	Approved	2	2025-06-22	2026-06-21
4	New Low Cost Carrier CD	Approved	2	2025-10-10	2026-04-30
\.


--
-- TOC entry 5121 (class 0 OID 16830)
-- Dependencies: 227
-- Data for Name: project_skill_required; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_skill_required (project_id, skill_id, status) FROM stdin;
1	1	Approved
1	4	Approved
1	5	Canceled
1	6	Approved
1	7	Approved
1	8	Approved
1	10	Approved
1	11	Approved
1	12	Approved
2	1	Approved
2	4	Approved
2	6	Approved
2	7	Approved
2	8	Approved
2	10	Approved
2	12	Approved
3	4	Approved
3	5	Canceled
3	6	Approved
3	7	Approved
4	4	Approved
4	6	Approved
4	7	Approved
4	9	Approved
\.


--
-- TOC entry 5122 (class 0 OID 16836)
-- Dependencies: 228
-- Data for Name: skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skill (skill_id, skill_name, status, skill_type) FROM stdin;
1	Java	Approved	Technology
3	ECCP	Canceled	Technology
4	Project Management	Approved	Experience
5	Scrum Master	Approved	Knowledge
6	QA Testing	Approved	Knowledge
7	Industry APIs	Approved	Knowledge
8	Operating Metrics	Approved	Experience
9	Agentic AI	Approved	Other
10	Data Processing	Approved	Experience
11	Data Storage	Approved	Technology
12	Product Feature Design	Approved	Experience
13	C#	Approved	Technology
16	QA Testing	Approved	Knowledge
17	React	Approved	Technology
18	Node.js	Approved	Technology
19	PostgreSQL	Approved	Technology
20	Project Management	Approved	Experience
21	Data Analysis	Approved	Knowledge
22	Docker	Approved	Technology
23	CI/CD	Approved	Technology
24	System Design	Approved	Knowledge
25	Python	Approved	Technology
\.


--
-- TOC entry 5127 (class 0 OID 16953)
-- Dependencies: 233
-- Data for Name: skill_request; Type: TABLE DATA; Schema: public; Owner: skills_user
--

COPY public.skill_request (request_id, requested_by, skill_name, skill_type, justification, status, created_at, resolved_at, resolved_by, resolution_notes, created_skill_id) FROM stdin;
114	514	API Governance 101	Other	Requested for upcoming work: API Governance 101	Requested	2025-11-21 20:27:27.264874	\N	\N	\N	\N
115	95	API Governance Advanced	Technology	Requested for upcoming work: API Governance Advanced	Requested	2025-12-03 05:49:27.264874	\N	\N	\N	\N
116	3	API Governance Fundamentals	Knowledge	Requested for upcoming work: API Governance Fundamentals	Requested	2025-11-21 21:28:27.264874	\N	\N	\N	\N
117	628	Budget Tracking 101	Other	Requested for upcoming work: Budget Tracking 101	Requested	2025-11-20 19:25:27.264874	\N	\N	\N	\N
118	417	Budget Tracking Advanced	Experience	Requested for upcoming work: Budget Tracking Advanced	Requested	2025-12-01 03:45:27.264874	\N	\N	\N	\N
119	889	Budget Tracking Essentials	Technology	Requested for upcoming work: Budget Tracking Essentials	Requested	2025-11-29 02:42:27.264874	\N	\N	\N	\N
120	53	Budget Tracking Pro	Other	Requested for upcoming work: Budget Tracking Pro	Requested	2025-11-16 16:17:27.264874	\N	\N	\N	\N
121	16	Cross-Team Sync Advanced	Other	Requested for upcoming work: Cross-Team Sync Advanced	Requested	2025-11-04 06:53:27.264874	\N	\N	\N	\N
122	416	Cross-Team Sync Essentials	Knowledge	Requested for upcoming work: Cross-Team Sync Essentials	Requested	2025-11-09 10:03:27.264874	\N	\N	\N	\N
123	251	Cross-Team Sync Fundamentals	Other	Requested for upcoming work: Cross-Team Sync Fundamentals	Requested	2025-11-17 17:19:27.264874	\N	\N	\N	\N
124	3	Observability Advanced	Technology	Requested for upcoming work: Observability Advanced	Requested	2025-11-07 08:59:27.264874	\N	\N	\N	\N
125	782	Observability Essentials	Knowledge	Requested for upcoming work: Observability Essentials	Requested	2025-12-01 03:45:27.264874	\N	\N	\N	\N
126	16	Observability Fundamentals	Experience	Requested for upcoming work: Observability Fundamentals	Requested	2025-11-28 01:40:27.264874	\N	\N	\N	\N
127	370	Observability Pro	Experience	Requested for upcoming work: Observability Pro	Requested	2025-11-07 09:00:27.264874	\N	\N	\N	\N
128	815	Platform Onboarding Advanced	Technology	Requested for upcoming work: Platform Onboarding Advanced	Requested	2025-12-01 03:45:27.264874	\N	\N	\N	\N
129	222	Platform Onboarding Fundamentals	Other	Requested for upcoming work: Platform Onboarding Fundamentals	Requested	2025-11-29 02:41:27.264874	\N	\N	\N	\N
130	370	Platform Onboarding Pro	Knowledge	Requested for upcoming work: Platform Onboarding Pro	Requested	2025-11-24 23:34:27.264874	\N	\N	\N	\N
131	610	Security Review 101	Other	Requested for upcoming work: Security Review 101	Requested	2025-12-01 04:46:27.264874	\N	\N	\N	\N
132	222	Security Review Advanced	Experience	Requested for upcoming work: Security Review Advanced	Requested	2025-11-05 07:56:27.264874	\N	\N	\N	\N
133	259	Security Review Essentials	Technology	Requested for upcoming work: Security Review Essentials	Requested	2025-11-05 07:56:27.264874	\N	\N	\N	\N
134	628	Security Review Pro	Other	Requested for upcoming work: Security Review Pro	Requested	2025-12-02 04:48:27.264874	\N	\N	\N	\N
135	979	wewe	Technology		Canceled	2025-12-03 06:01:18.709422	2025-12-03 06:01:29.064	979	\N	\N
136	979	q	Technology	we	Canceled	2025-12-03 06:19:53.738844	2025-12-03 06:20:05.724	979	\N	\N
\.


--
-- TOC entry 5124 (class 0 OID 16844)
-- Dependencies: 230
-- Data for Name: team_high_value_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_high_value_skills (id, team_id, skill_id, priority, notes, assigned_by, created_at) FROM stdin;
3	987	12	High		987	2025-12-02 21:18:57.422505
4	987	6	High		987	2025-12-02 21:30:33.988942
5	48	1	Medium		48	2025-12-02 22:12:58.664668
6	48	9	Medium		48	2025-12-02 22:13:03.575355
7	48	6	High		48	2025-12-02 22:18:42.559719
8	967	7	Medium		967	2025-12-02 22:21:03.667296
9	967	6	High		967	2025-12-02 22:21:39.315194
11	979	10	Medium		979	2025-12-03 01:27:54.921662
12	979	7	High		979	2025-12-03 01:28:08.922575
13	979	13	High		979	2025-12-03 04:09:23.75746
\.


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 220
-- Name: organization_organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_organization_id_seq', 1, false);


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 222
-- Name: person_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_person_id_seq', 1, false);


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 226
-- Name: project_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.project_project_id_seq', 1, false);


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 232
-- Name: skill_request_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skills_user
--

SELECT pg_catalog.setval('public.skill_request_request_id_seq', 136, true);


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 229
-- Name: skill_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skill_skill_id_seq', 25, true);


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 231
-- Name: team_high_value_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.team_high_value_skills_id_seq', 13, true);


--
-- TOC entry 4927 (class 2606 OID 16861)
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (organization_id);


--
-- TOC entry 4929 (class 2606 OID 16863)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);


--
-- TOC entry 4933 (class 2606 OID 16865)
-- Name: person_project_assignment person_project_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_project_assignment
    ADD CONSTRAINT person_project_assignment_pkey PRIMARY KEY (person_id, project_id);


--
-- TOC entry 4936 (class 2606 OID 16867)
-- Name: person_skill person_skill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_skill
    ADD CONSTRAINT person_skill_pkey PRIMARY KEY (person_id, skill_id);


--
-- TOC entry 4931 (class 2606 OID 16869)
-- Name: person person_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_username_key UNIQUE (username);


--
-- TOC entry 4938 (class 2606 OID 16871)
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (project_id);


--
-- TOC entry 4940 (class 2606 OID 16873)
-- Name: project_skill_required project_skill_required_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_skill_required
    ADD CONSTRAINT project_skill_required_pkey PRIMARY KEY (project_id, skill_id);


--
-- TOC entry 4942 (class 2606 OID 16875)
-- Name: skill skill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill
    ADD CONSTRAINT skill_pkey PRIMARY KEY (skill_id);


--
-- TOC entry 4948 (class 2606 OID 16967)
-- Name: skill_request skill_request_pkey; Type: CONSTRAINT; Schema: public; Owner: skills_user
--

ALTER TABLE ONLY public.skill_request
    ADD CONSTRAINT skill_request_pkey PRIMARY KEY (request_id);


--
-- TOC entry 4944 (class 2606 OID 16877)
-- Name: team_high_value_skills team_high_value_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_high_value_skills
    ADD CONSTRAINT team_high_value_skills_pkey PRIMARY KEY (id);


--
-- TOC entry 4946 (class 2606 OID 16879)
-- Name: team_high_value_skills team_high_value_skills_team_id_skill_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_high_value_skills
    ADD CONSTRAINT team_high_value_skills_team_id_skill_id_key UNIQUE (team_id, skill_id);


--
-- TOC entry 4934 (class 1259 OID 16880)
-- Name: idx_person_skill_status_requested_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_skill_status_requested_at ON public.person_skill USING btree (status, requested_at);


--
-- TOC entry 4949 (class 1259 OID 16983)
-- Name: skill_request_unique_active; Type: INDEX; Schema: public; Owner: skills_user
--

CREATE UNIQUE INDEX skill_request_unique_active ON public.skill_request USING btree (lower((skill_name)::text)) WHERE (status = 'Requested'::public.person_skill_status_enum);


--
-- TOC entry 4950 (class 2606 OID 16881)
-- Name: organization fk_org_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT fk_org_manager FOREIGN KEY (organization_manager_person_id) REFERENCES public.person(person_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4951 (class 2606 OID 16886)
-- Name: person fk_person_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT fk_person_manager FOREIGN KEY (manager_person_id) REFERENCES public.person(person_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4952 (class 2606 OID 16891)
-- Name: person fk_person_org; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT fk_person_org FOREIGN KEY (member_of_organization_id) REFERENCES public.organization(organization_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4953 (class 2606 OID 16896)
-- Name: person_project_assignment person_project_assignment_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_project_assignment
    ADD CONSTRAINT person_project_assignment_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4954 (class 2606 OID 16901)
-- Name: person_project_assignment person_project_assignment_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_project_assignment
    ADD CONSTRAINT person_project_assignment_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(project_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4955 (class 2606 OID 16906)
-- Name: person_skill person_skill_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_skill
    ADD CONSTRAINT person_skill_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4956 (class 2606 OID 16911)
-- Name: person_skill person_skill_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_skill
    ADD CONSTRAINT person_skill_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skill(skill_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4957 (class 2606 OID 16916)
-- Name: project project_project_owning_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_project_owning_organization_id_fkey FOREIGN KEY (project_owning_organization_id) REFERENCES public.organization(organization_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4958 (class 2606 OID 16921)
-- Name: project_skill_required project_skill_required_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_skill_required
    ADD CONSTRAINT project_skill_required_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(project_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4959 (class 2606 OID 16926)
-- Name: project_skill_required project_skill_required_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_skill_required
    ADD CONSTRAINT project_skill_required_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skill(skill_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4963 (class 2606 OID 16978)
-- Name: skill_request skill_request_created_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: skills_user
--

ALTER TABLE ONLY public.skill_request
    ADD CONSTRAINT skill_request_created_skill_id_fkey FOREIGN KEY (created_skill_id) REFERENCES public.skill(skill_id);


--
-- TOC entry 4964 (class 2606 OID 16968)
-- Name: skill_request skill_request_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: skills_user
--

ALTER TABLE ONLY public.skill_request
    ADD CONSTRAINT skill_request_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.person(person_id);


--
-- TOC entry 4965 (class 2606 OID 16973)
-- Name: skill_request skill_request_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: skills_user
--

ALTER TABLE ONLY public.skill_request
    ADD CONSTRAINT skill_request_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.person(person_id);


--
-- TOC entry 4960 (class 2606 OID 16931)
-- Name: team_high_value_skills team_high_value_skills_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_high_value_skills
    ADD CONSTRAINT team_high_value_skills_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.person(person_id) ON DELETE SET NULL;


--
-- TOC entry 4961 (class 2606 OID 16936)
-- Name: team_high_value_skills team_high_value_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_high_value_skills
    ADD CONSTRAINT team_high_value_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skill(skill_id) ON DELETE CASCADE;


--
-- TOC entry 4962 (class 2606 OID 16941)
-- Name: team_high_value_skills team_high_value_skills_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_high_value_skills
    ADD CONSTRAINT team_high_value_skills_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.person(person_id) ON DELETE CASCADE;


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE organization; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.organization TO skills_user;


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE organization_organization_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.organization_organization_id_seq TO skills_user;


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE person; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.person TO skills_user;


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE person_person_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.person_person_id_seq TO skills_user;


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE person_project_assignment; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.person_project_assignment TO skills_user;


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE person_skill; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.person_skill TO skills_user;


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE project; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.project TO skills_user;


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 226
-- Name: SEQUENCE project_project_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.project_project_id_seq TO skills_user;


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE project_skill_required; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.project_skill_required TO skills_user;


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE skill; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.skill TO skills_user;


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE skill_skill_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.skill_skill_id_seq TO skills_user;


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE team_high_value_skills; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.team_high_value_skills TO skills_user;


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE team_high_value_skills_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.team_high_value_skills_id_seq TO skills_user;


--
-- TOC entry 2109 (class 826 OID 16950)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO skills_user;


--
-- TOC entry 2110 (class 826 OID 16951)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO skills_user;


--
-- TOC entry 2108 (class 826 OID 16949)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO skills_user;


--
-- TOC entry 2107 (class 826 OID 16948)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO skills_user;


-- Completed on 2025-12-03 06:29:26

--
-- PostgreSQL database dump complete
--

\unrestrict gaL3OF3hVAXo1K4Tbkhf0FddcUUiv0cfx7U5qbfWBQQ07VNYYifAU7ryOXjdDW7

