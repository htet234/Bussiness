--
-- PostgreSQL database dump
--

\restrict VIAgQ2Yul8z0mViYfTai29sLL7chxghfWqqLpLbMgGL5iREJIJX34xCoLiAYe8G

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: budgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budgets (
    id integer NOT NULL,
    month character varying(7) NOT NULL,
    category text NOT NULL,
    amount numeric(12,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    subcategory text
);


ALTER TABLE public.budgets OWNER TO postgres;

--
-- Name: budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.budgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.budgets_id_seq OWNER TO postgres;

--
-- Name: budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.budgets_id_seq OWNED BY public.budgets.id;


--
-- Name: checking_account_main; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checking_account_main (
    date date,
    transaction_id text,
    description text,
    category text,
    type text,
    amount numeric,
    balance numeric
);


ALTER TABLE public.checking_account_main OWNER TO postgres;

--
-- Name: checking_account_secondary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checking_account_secondary (
    date date,
    transaction_id text,
    description text,
    category text,
    type text,
    amount numeric,
    balance numeric
);


ALTER TABLE public.checking_account_secondary OWNER TO postgres;

--
-- Name: company_budgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_budgets (
    id integer NOT NULL,
    month character varying(7) NOT NULL,
    amount numeric(12,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.company_budgets OWNER TO postgres;

--
-- Name: company_budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_budgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.company_budgets_id_seq OWNER TO postgres;

--
-- Name: company_budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_budgets_id_seq OWNED BY public.company_budgets.id;


--
-- Name: credit_card_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_card_account (
    date date,
    transaction_id text,
    vendor text,
    category text,
    type text,
    amount numeric,
    balance numeric
);


ALTER TABLE public.credit_card_account OWNER TO postgres;

--
-- Name: employee_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_profiles (
    id integer NOT NULL,
    name text,
    role text,
    hourly_rate numeric,
    is_active boolean DEFAULT true,
    is_seasonal boolean DEFAULT false
);


ALTER TABLE public.employee_profiles OWNER TO postgres;

--
-- Name: overall_budgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.overall_budgets (
    id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    description text,
    month text
);


ALTER TABLE public.overall_budgets OWNER TO postgres;

--
-- Name: overall_budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.overall_budgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.overall_budgets_id_seq OWNER TO postgres;

--
-- Name: overall_budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.overall_budgets_id_seq OWNED BY public.overall_budgets.id;


--
-- Name: payroll_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_history (
    employee_id integer,
    employee_name text,
    role text,
    pay_date date,
    gross_pay numeric,
    federal_tax numeric,
    provincial_tax numeric,
    cpp numeric,
    ei numeric,
    other_deductions numeric,
    net_pay numeric,
    employer_cpp numeric,
    employer_ei numeric,
    tips numeric,
    travel_reimbursement numeric,
    total_business_cost numeric
);


ALTER TABLE public.payroll_history OWNER TO postgres;

--
-- Name: payroll_ledger; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.payroll_ledger AS
 SELECT p.pay_date,
    e.name,
    e.role,
    p.gross_pay,
    p.net_pay,
    p.total_business_cost,
    p.tips,
    p.federal_tax,
    p.provincial_tax,
    p.cpp,
    p.employer_cpp,
    p.ei,
    p.employer_ei
   FROM (public.payroll_history p
     JOIN public.employee_profiles e ON ((p.employee_id = e.id)));


ALTER VIEW public.payroll_ledger OWNER TO postgres;

--
-- Name: payroll_system_ledger; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.payroll_system_ledger AS
 SELECT employee_name AS name,
    role,
    count(*) AS total_paychecks_issued,
    sum(gross_pay) AS total_gross_life,
    sum(((((gross_pay + employer_cpp) + employer_ei) + tips) + travel_reimbursement)) AS total_cash_spent_by_business,
    sum(tips) AS total_tips_distributed
   FROM public.payroll_history
  GROUP BY employee_name, role;


ALTER VIEW public.payroll_system_ledger OWNER TO postgres;

--
-- Name: budgets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets ALTER COLUMN id SET DEFAULT nextval('public.budgets_id_seq'::regclass);


--
-- Name: company_budgets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_budgets ALTER COLUMN id SET DEFAULT nextval('public.company_budgets_id_seq'::regclass);


--
-- Name: overall_budgets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.overall_budgets ALTER COLUMN id SET DEFAULT nextval('public.overall_budgets_id_seq'::regclass);


--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.budgets (id, month, category, amount, created_at, subcategory) FROM stdin;
133	2026-02	Operating expense	12.00	2026-02-08 20:16:24.991077	Local Print Shop
167	2026-02	COGS	2.00	2026-02-08 21:03:39.024871	Coffee Supplier Payment
134	2026-02	Operating expense	2.00	2026-02-08 20:18:24.058683	Rent Payment
135	2026-02	Operating expense	1.00	2026-02-08 20:20:02.883035	Miscellaneous
172	2022-01	Operating expense	45000.00	2026-02-08 21:40:00.625886	\N
173	2022-01	Operating expense	23000.00	2026-02-08 21:40:00.625886	Utilities
174	2022-01	Operating expense	4000.00	2026-02-08 21:40:00.625886	Utility Bill Payment
175	2022-01	Operating expense	3000.00	2026-02-08 21:40:00.625886	Marketing
176	2022-01	Operating expense	3000.00	2026-02-08 21:40:00.625886	Marketing / promotion
177	2022-01	Operating expense	7000.00	2026-02-08 21:41:02.63162	Rent Payment
178	2026-02	COGS	10.00	2026-02-08 21:59:31.202501	Supplies
179	2026-02	COGS	1.00	2026-02-09 18:33:31.453716	Packaging
105	2026-02	COGS	2500.00	2026-02-06 13:30:20.905117	\N
107	2026-02	Operating expense	2000.00	2026-02-06 13:35:13.770323	\N
136	2026-02	Operating expense	1.00	2026-02-08 20:20:07.517406	Facebook Ads
137	2022-01	COGS	50000.00	2026-02-08 20:25:19.237065	\N
106	2026-02	COGS	20.00	2026-02-06 13:30:28.536132	Bakery Payment
108	2026-02	Operating expense	23.00	2026-02-06 13:35:21.029312	Utilities
109	2026-02	COGS	5.00	2026-02-06 13:36:39.767639	Ingredients / Groceries
111	2026-04	COGS	50.00	2026-02-07 22:33:45.069323	\N
112	2026-04	Operating expense	50.00	2026-02-07 22:34:02.81902	\N
114	2026-03	COGS	45.00	2026-02-08 12:56:52.051474	\N
138	2022-01	COGS	20000.00	2026-02-08 20:25:19.237065	Bakery Payment
139	2022-01	COGS	12000.00	2026-02-08 20:25:19.237065	Supplies
140	2022-01	COGS	5000.00	2026-02-08 20:25:19.237065	Ingredients / Groceries
141	2022-01	COGS	13000.00	2026-02-08 20:25:19.237065	Packaging
\.


--
-- Data for Name: checking_account_main; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checking_account_main (date, transaction_id, description, category, type, amount, balance) FROM stdin;
2025-12-25	\N	Rent Payment	Operating Expense	\N	337	\N
2025-12-26	\N	Daily Sales Deposit	Sales Revenue	\N	603	\N
2025-12-26	\N	Rent Payment	Operating Expense	\N	440	\N
2025-12-27	\N	Daily Sales Deposit	Sales Revenue	\N	688	\N
2025-12-28	\N	Daily Sales Deposit	Sales Revenue	\N	756	\N
2025-12-29	\N	Daily Sales Deposit	Sales Revenue	\N	409	\N
2025-12-30	\N	Daily Sales Deposit	Sales Revenue	\N	499	\N
2025-12-30	\N	Coffee Supplier Payment	COGS	\N	322	\N
2025-08-01	TX00041	Daily Sales Deposit	Sales Revenue	Credit	907	41885
2025-08-02	TX00042	Daily Sales Deposit	Sales Revenue	Credit	1066	42951
2025-08-03	TX00043	Daily Sales Deposit	Sales Revenue	Credit	1109	44060
2025-08-04	TX00044	Daily Sales Deposit	Sales Revenue	Credit	887	44947
2025-08-05	TX00045	Daily Sales Deposit	Sales Revenue	Credit	740	45687
2025-08-06	TX00046	Daily Sales Deposit	Sales Revenue	Credit	1000	46687
2025-08-06	TX00047	Bakery Payment	COGS	Debit	426	46261
2025-08-07	TX00048	Daily Sales Deposit	Sales Revenue	Credit	1043	47304
2025-08-08	TX00049	Daily Sales Deposit	Sales Revenue	Credit	835	48139
2025-08-08	TX00050	Utility Bill Payment	Operating Expense	Debit	238	47901
2025-08-09	TX00051	Daily Sales Deposit	Sales Revenue	Credit	780	48681
2025-08-10	TX00052	Daily Sales Deposit	Sales Revenue	Credit	1118	49799
2025-08-11	TX00053	Daily Sales Deposit	Sales Revenue	Credit	960	50759
2025-08-12	TX00054	Daily Sales Deposit	Sales Revenue	Credit	740	51499
2025-08-13	TX00055	Daily Sales Deposit	Sales Revenue	Credit	900	52399
2025-08-14	TX00056	Daily Sales Deposit	Sales Revenue	Credit	1117	53516
2025-08-14	TX00057	Maintenance Payment	Operating Expense	Debit	161	53355
2025-08-15	TX00058	Daily Sales Deposit	Sales Revenue	Credit	798	54153
2025-08-16	TX00059	Daily Sales Deposit	Sales Revenue	Credit	913	55066
2025-08-17	TX00060	Daily Sales Deposit	Sales Revenue	Credit	1148	56214
2025-08-18	TX00061	Daily Sales Deposit	Sales Revenue	Credit	1130	57344
2025-08-19	TX00062	Daily Sales Deposit	Sales Revenue	Credit	956	58300
2025-08-20	TX00063	Daily Sales Deposit	Sales Revenue	Credit	954	59254
2025-12-01	\N	Daily Sales Deposit	Sales Revenue	\N	585	\N
2025-12-02	\N	Daily Sales Deposit	Sales Revenue	\N	524	\N
2025-12-03	\N	Daily Sales Deposit	Sales Revenue	\N	457	\N
2025-12-03	\N	Coffee Supplier Payment	COGS	\N	279	\N
2025-12-04	\N	Daily Sales Deposit	Sales Revenue	\N	725	\N
2025-12-05	\N	Daily Sales Deposit	Sales Revenue	\N	500	\N
2025-12-06	\N	Daily Sales Deposit	Sales Revenue	\N	452	\N
2025-12-07	\N	Daily Sales Deposit	Sales Revenue	\N	507	\N
2025-12-08	\N	Daily Sales Deposit	Sales Revenue	\N	595	\N
2025-12-09	\N	Daily Sales Deposit	Sales Revenue	\N	771	\N
2025-12-10	\N	Daily Sales Deposit	Sales Revenue	\N	754	\N
2025-12-11	\N	Daily Sales Deposit	Sales Revenue	\N	707	\N
2025-12-11	\N	Rent Payment	Operating Expense	\N	469	\N
2025-12-12	\N	Daily Sales Deposit	Sales Revenue	\N	505	\N
2025-12-13	\N	Daily Sales Deposit	Sales Revenue	\N	544	\N
2025-12-14	\N	Daily Sales Deposit	Sales Revenue	\N	674	\N
2025-12-15	\N	Daily Sales Deposit	Sales Revenue	\N	745	\N
2025-12-15	\N	Bakery Payment	COGS	\N	216	\N
2025-12-16	\N	Daily Sales Deposit	Sales Revenue	\N	795	\N
2025-12-17	\N	Daily Sales Deposit	Sales Revenue	\N	457	\N
2025-12-18	\N	Daily Sales Deposit	Sales Revenue	\N	638	\N
2025-12-19	\N	Daily Sales Deposit	Sales Revenue	\N	525	\N
2025-12-19	\N	Maintenance Payment	Operating Expense	\N	188	\N
2025-12-20	\N	Daily Sales Deposit	Sales Revenue	\N	772	\N
2025-12-21	\N	Daily Sales Deposit	Sales Revenue	\N	588	\N
2025-12-22	\N	Daily Sales Deposit	Sales Revenue	\N	468	\N
2025-12-23	\N	Daily Sales Deposit	Sales Revenue	\N	646	\N
2025-12-23	\N	Utility Bill Payment	Operating Expense	\N	253	\N
2025-12-24	\N	Daily Sales Deposit	Sales Revenue	\N	485	\N
2025-12-24	\N	Maintenance Payment	Operating Expense	\N	319	\N
2025-12-25	\N	Daily Sales Deposit	Sales Revenue	\N	446	\N
2025-08-21	TX00064	Daily Sales Deposit	Sales Revenue	Credit	982	60236
2025-08-22	TX00065	Daily Sales Deposit	Sales Revenue	Credit	714	60950
2025-08-22	TX00066	Maintenance Payment	Operating Expense	Debit	479	60471
2025-08-23	TX00067	Daily Sales Deposit	Sales Revenue	Credit	878	61349
2025-08-23	TX00068	Bakery Payment	COGS	Debit	330	61019
2025-08-24	TX00069	Daily Sales Deposit	Sales Revenue	Credit	751	61770
2025-08-25	TX00070	Daily Sales Deposit	Sales Revenue	Credit	1087	62857
2025-08-26	TX00071	Daily Sales Deposit	Sales Revenue	Credit	1106	63963
2025-08-27	TX00072	Daily Sales Deposit	Sales Revenue	Credit	842	64805
2025-09-02	TX00075	Daily Sales Deposit	Sales Revenue	Credit	485	66751
2025-09-03	TX00076	Daily Sales Deposit	Sales Revenue	Credit	569	67320
2025-09-04	TX00077	Daily Sales Deposit	Sales Revenue	Credit	533	67853
2025-09-05	TX00078	Daily Sales Deposit	Sales Revenue	Credit	507	68360
2025-09-05	TX00079	Utility Bill Payment	Operating Expense	Debit	385	67975
2025-09-06	TX00080	Daily Sales Deposit	Sales Revenue	Credit	527	68502
2025-09-07	TX00081	Daily Sales Deposit	Sales Revenue	Credit	747	69249
2025-09-08	TX00082	Daily Sales Deposit	Sales Revenue	Credit	589	69838
2025-09-08	TX00083	Utility Bill Payment	Operating Expense	Debit	476	69362
2025-09-09	TX00084	Daily Sales Deposit	Sales Revenue	Credit	520	69882
2025-09-10	TX00085	Daily Sales Deposit	Sales Revenue	Credit	632	70514
2025-09-11	TX00086	Daily Sales Deposit	Sales Revenue	Credit	597	71111
2025-09-12	TX00087	Daily Sales Deposit	Sales Revenue	Credit	536	71647
2025-09-13	TX00088	Daily Sales Deposit	Sales Revenue	Credit	624	72271
2025-09-13	TX00089	Utility Bill Payment	Operating Expense	Debit	271	72000
2025-09-14	TX00090	Daily Sales Deposit	Sales Revenue	Credit	773	72773
2025-09-15	TX00091	Daily Sales Deposit	Sales Revenue	Credit	632	73405
2025-09-16	TX00092	Daily Sales Deposit	Sales Revenue	Credit	717	74122
2025-09-17	TX00093	Daily Sales Deposit	Sales Revenue	Credit	451	74573
2025-09-18	TX00094	Daily Sales Deposit	Sales Revenue	Credit	694	75267
2025-09-19	TX00095	Daily Sales Deposit	Sales Revenue	Credit	512	75779
2025-09-19	TX00096	Utility Bill Payment	Operating Expense	Debit	180	75599
2025-09-20	TX00097	Daily Sales Deposit	Sales Revenue	Credit	512	76111
2025-09-21	TX00098	Daily Sales Deposit	Sales Revenue	Credit	619	76730
2025-09-21	TX00099	Bakery Payment	COGS	Debit	323	76407
2025-09-22	TX00100	Daily Sales Deposit	Sales Revenue	Credit	784	77191
2025-09-25	TX00103	Daily Sales Deposit	Sales Revenue	Credit	646	78983
2025-09-26	TX00104	Daily Sales Deposit	Sales Revenue	Credit	602	79585
2025-09-27	TX00105	Daily Sales Deposit	Sales Revenue	Credit	654	80239
2025-09-28	TX00106	Daily Sales Deposit	Sales Revenue	Credit	724	80963
2025-09-29	TX00107	Daily Sales Deposit	Sales Revenue	Credit	597	81560
2025-09-30	TX00108	Daily Sales Deposit	Sales Revenue	Credit	639	82199
2025-09-30	TX00109	Daily Sales Deposit	Sales Revenue	Credit	600	82799
2025-10-01	TX00110	Daily Sales Deposit	Sales Revenue	Credit	725	83524
2025-10-02	TX00111	Daily Sales Deposit	Sales Revenue	Credit	658	84182
2025-10-03	TX00112	Daily Sales Deposit	Sales Revenue	Credit	745	84927
2025-10-04	TX00113	Daily Sales Deposit	Sales Revenue	Credit	546	85473
2025-10-05	TX00114	Daily Sales Deposit	Sales Revenue	Credit	598	86071
2025-10-05	TX00115	Coffee Supplier Payment	COGS	Debit	227	85844
2025-10-06	TX00116	Daily Sales Deposit	Sales Revenue	Credit	759	86603
2025-10-06	TX00117	Coffee Supplier Payment	COGS	Debit	250	86353
2025-10-07	TX00118	Daily Sales Deposit	Sales Revenue	Credit	498	86851
2025-10-08	TX00119	Daily Sales Deposit	Sales Revenue	Credit	543	87394
2025-10-09	TX00120	Daily Sales Deposit	Sales Revenue	Credit	459	87853
2025-10-10	TX00121	Daily Sales Deposit	Sales Revenue	Credit	784	88637
2025-10-10	TX00122	Maintenance Payment	Operating Expense	Debit	239	88398
2025-10-11	TX00123	Daily Sales Deposit	Sales Revenue	Credit	436	88834
2025-10-12	TX00124	Daily Sales Deposit	Sales Revenue	Credit	408	89242
2025-10-13	TX00125	Daily Sales Deposit	Sales Revenue	Credit	546	89788
2025-10-14	TX00126	Daily Sales Deposit	Sales Revenue	Credit	530	90318
2025-10-15	TX00127	Daily Sales Deposit	Sales Revenue	Credit	453	90771
2025-10-16	TX00128	Daily Sales Deposit	Sales Revenue	Credit	515	91286
2025-10-16	TX00129	Rent Payment	Operating Expense	Debit	203	91083
2025-10-17	TX00130	Daily Sales Deposit	Sales Revenue	Credit	653	91736
2025-10-17	TX00131	Bakery Payment	COGS	Debit	198	91538
2025-10-18	TX00132	Daily Sales Deposit	Sales Revenue	Credit	748	92286
2025-10-19	TX00133	Daily Sales Deposit	Sales Revenue	Credit	765	93051
2025-10-20	TX00134	Daily Sales Deposit	Sales Revenue	Credit	709	93760
2025-10-21	TX00135	Daily Sales Deposit	Sales Revenue	Credit	568	94328
2025-10-21	TX00136	Bakery Payment	COGS	Debit	167	94161
2025-10-22	TX00137	Daily Sales Deposit	Sales Revenue	Credit	797	94958
2025-10-23	TX00138	Daily Sales Deposit	Sales Revenue	Credit	783	95741
2025-10-24	TX00139	Daily Sales Deposit	Sales Revenue	Credit	594	96335
2025-10-25	TX00140	Daily Sales Deposit	Sales Revenue	Credit	432	96767
2025-10-26	TX00141	Daily Sales Deposit	Sales Revenue	Credit	770	97537
2025-10-27	TX00142	Daily Sales Deposit	Sales Revenue	Credit	421	97958
2025-10-28	TX00143	Daily Sales Deposit	Sales Revenue	Credit	437	98395
2025-10-29	TX00144	Daily Sales Deposit	Sales Revenue	Credit	450	98845
2025-10-30	TX00145	Daily Sales Deposit	Sales Revenue	Credit	682	99527
2025-11-01	TX00146	Daily Sales Deposit	Sales Revenue	Credit	676	100203
2025-11-02	TX00147	Daily Sales Deposit	Sales Revenue	Credit	683	100886
2025-11-03	TX00148	Daily Sales Deposit	Sales Revenue	Credit	716	101602
2025-11-04	TX00149	Daily Sales Deposit	Sales Revenue	Credit	403	102005
2025-11-04	TX00150	Bakery Payment	COGS	Debit	148	101857
2025-11-05	TX00151	Daily Sales Deposit	Sales Revenue	Credit	571	102428
2025-11-06	TX00152	Daily Sales Deposit	Sales Revenue	Credit	445	102873
2025-11-07	TX00153	Daily Sales Deposit	Sales Revenue	Credit	498	103371
2025-11-08	TX00154	Daily Sales Deposit	Sales Revenue	Credit	436	103807
2025-09-23	TX00101	Daily Sales Deposit	Sales Revenue	Credit	529	77720
2025-09-24	TX00102	Daily Sales Deposit	Sales Revenue	Credit	617	78337
2025-08-28	TX00073	Daily Sales Deposit	Sales Revenue	Credit	735	65540
2025-09-01	TX00074	Daily Sales Deposit	Sales Revenue	Credit	726	66266
2025-11-09	TX00155	Daily Sales Deposit	Sales Revenue	Credit	701	104508
2025-11-10	TX00156	Daily Sales Deposit	Sales Revenue	Credit	498	105006
2025-11-11	TX00157	Daily Sales Deposit	Sales Revenue	Credit	515	105521
2025-11-12	TX00158	Daily Sales Deposit	Sales Revenue	Credit	560	106081
2025-11-13	TX00159	Daily Sales Deposit	Sales Revenue	Credit	527	106608
2025-11-14	TX00160	Daily Sales Deposit	Sales Revenue	Credit	622	107230
2025-11-15	TX00161	Daily Sales Deposit	Sales Revenue	Credit	722	107952
2025-11-16	TX00162	Daily Sales Deposit	Sales Revenue	Credit	679	108631
2025-11-17	TX00163	Daily Sales Deposit	Sales Revenue	Credit	741	109372
2025-11-18	TX00164	Daily Sales Deposit	Sales Revenue	Credit	526	109898
2025-11-19	TX00165	Daily Sales Deposit	Sales Revenue	Credit	785	110683
2025-11-20	TX00166	Daily Sales Deposit	Sales Revenue	Credit	503	111186
2025-11-21	TX00167	Daily Sales Deposit	Sales Revenue	Credit	698	111884
2025-11-22	TX00168	Daily Sales Deposit	Sales Revenue	Credit	438	112322
2025-11-23	TX00169	Daily Sales Deposit	Sales Revenue	Credit	646	112968
2025-11-24	TX00170	Daily Sales Deposit	Sales Revenue	Credit	705	113673
2025-11-25	TX00171	Daily Sales Deposit	Sales Revenue	Credit	412	114085
2025-11-25	TX00172	Bakery Payment	COGS	Debit	490	113595
2025-11-26	TX00173	Daily Sales Deposit	Sales Revenue	Credit	435	114030
2025-11-27	TX00174	Daily Sales Deposit	Sales Revenue	Credit	720	114750
2025-11-27	TX00175	Rent Payment	Operating Expense	Debit	499	114251
2025-11-28	TX00176	Daily Sales Deposit	Sales Revenue	Credit	770	115021
2025-11-29	TX00177	Daily Sales Deposit	Sales Revenue	Credit	491	115512
2025-11-30	TX00178	Daily Sales Deposit	Sales Revenue	Credit	687	116199
2025-11-30	TX00179	Daily Sales Deposit	Sales Revenue	Credit	741	116940
\.


--
-- Data for Name: checking_account_secondary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checking_account_secondary (date, transaction_id, description, category, type, amount, balance) FROM stdin;
2025-08-01	SC00001	Transfer from Main	Transfer	Credit	3403	5403
2025-08-15	SC00002	Payroll Funding	Payroll	Debit	2688	2715
2025-09-01	SC00003	Transfer from Main	Transfer	Credit	5779	8494
2025-09-15	SC00004	Payroll Funding	Payroll	Debit	5216	3278
2025-10-01	SC00005	Transfer from Main	Transfer	Credit	5579	8857
2025-10-15	SC00006	Payroll Funding	Payroll	Debit	5228	3629
2025-11-01	SC00007	Transfer from Main	Transfer	Credit	4712	8341
2025-11-15	SC00008	Payroll Funding	Payroll	Debit	4093	4248
2025-12-01	SC00009	Transfer from Main	Transfer	Credit	4273	8521
2025-12-15	SC00010	Payroll Funding	Payroll	Debit	3957	4564
\.


--
-- Data for Name: company_budgets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company_budgets (id, month, amount, created_at) FROM stdin;
1	2026-02	200.00	2026-02-03 21:22:14.346334
\.


--
-- Data for Name: credit_card_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_card_account (date, transaction_id, vendor, category, type, amount, balance) FROM stdin;
2025-12-04	\N	Coffee Supplier	Marketing	\N	107	\N
2025-12-06	\N	Payment to CC	Payment	\N	551	\N
2025-12-11	\N	Facebook Ads	Utilities	\N	457	\N
2025-12-13	\N	Payment to CC	Payment	\N	392	\N
2025-12-18	\N	Utility Company	Supplies	\N	410	\N
2025-12-25	\N	Coffee Supplier	Supplies	\N	513	\N
2025-08-05	CC00008	Coffee Supplier	Marketing	Debit	179	1331
2025-08-12	CC00009	Facebook Ads	Marketing	Debit	449	1780
2025-08-19	CC00010	Utility Company	Other	Debit	363	2143
2025-08-26	CC00011	Coffee Supplier	Other	Debit	163	2306
2025-09-05	CC00012	Facebook Ads	Utilities	Debit	206	2512
2025-09-12	CC00013	Facebook Ads	Marketing	Debit	264	2776
2025-09-19	CC00014	Local Print Shop	Utilities	Debit	411	3187
2025-09-26	CC00015	Utility Company	Marketing	Debit	207	3394
2025-09-28	CC00016	Payment to CC	Payment	Credit	533	2861
2025-10-02	CC00017	Facebook Ads	Utilities	Debit	229	3090
2025-10-04	CC00018	Payment to CC	Payment	Credit	481	2609
2025-10-09	CC00019	Facebook Ads	Utilities	Debit	384	2993
2025-10-11	CC00020	Payment to CC	Payment	Credit	684	2309
2025-10-16	CC00021	Utility Company	Marketing	Debit	344	2653
2025-10-18	CC00022	Payment to CC	Payment	Credit	405	2248
2025-10-23	CC00023	Coffee Supplier	Other	Debit	111	2359
2025-10-30	CC00024	Utility Company	Utilities	Debit	315	2674
2025-11-02	CC00025	Payment to CC	Payment	Credit	416	2258
2025-11-07	CC00026	Facebook Ads	Marketing	Debit	405	2663
2025-11-14	CC00027	Utility Company	Utilities	Debit	283	2946
2025-11-21	CC00028	Coffee Supplier	Other	Debit	527	3473
2025-11-23	CC00029	Payment to CC	Payment	Credit	507	2966
2025-11-28	CC00030	Coffee Supplier	Supplies	Debit	435	3401
\.


--
-- Data for Name: employee_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_profiles (id, name, role, hourly_rate, is_active, is_seasonal) FROM stdin;
1	Alice Johnson	Owner	25.00	t	f
2	Brian Smith	Barista	16.50	t	f
3	Chloe Davis	Barista	16.00	t	f
4	Daniel Lee	Manager	18.75	t	f
5	Eva Thompson	Independent Contractor	17.50	t	f
6	Frank White	Seasonal Barista	15.00	t	t
\.


--
-- Data for Name: overall_budgets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.overall_budgets (id, amount, description, month) FROM stdin;
54	100.00	\N	2026-04
56	500.00	\N	2026-03
57	100000.00	First month	2022-01
53	5004.00	\N	2026-02
\.


--
-- Data for Name: payroll_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_history (employee_id, employee_name, role, pay_date, gross_pay, federal_tax, provincial_tax, cpp, ei, other_deductions, net_pay, employer_cpp, employer_ei, tips, travel_reimbursement, total_business_cost) FROM stdin;
1	Alice Johnson	Barista	2025-12-15	1765	0	0	0	0	0	1765	0	0	0	0	1765
2	 Brian Smith	Barista	2025-12-15	1740	0	0	0	0	0	1740	0	0	0	0	1740
3	Chloe Davis	Manager	2025-12-15	2229	0	0	0	0	0	2229	0	0	0	0	2229
4	Daniel Lee	Marketing Contractor	2025-12-15	1262	0	0	0	0	0	1262	0	0	0	0	1262
1	Alice Johnson	Owner	2025-12-10	1981.21	237.75	99.06	117.88	32.29	0	1494.23	117.88	45.21	0	0	2144.30
1	Alice Johnson	Owner	2025-12-24	1986.42	238.37	99.32	118.19	32.38	0	1498.16	118.19	45.33	0	0	2149.94
2	Brian Smith	Barista	2025-12-10	1160.82	139.3	58.04	69.07	18.92	0	875.49	69.07	26.49	171.56	0	1256.38
2	Brian Smith	Barista	2025-12-24	1311.7	157.4	65.59	78.05	21.38	0	989.29	78.05	29.93	229.26	0	1419.68
3	Chloe Davis	Barista	2025-12-10	1265.39	151.85	63.27	75.29	20.63	0	954.36	75.29	28.88	186.55	0	1369.56
3	Chloe Davis	Barista	2025-12-24	1295.5	155.46	64.77	77.08	21.12	0	977.07	77.08	29.56	192.96	0	1402.14
4	Daniel Lee	Manager	2025-12-10	1481.14	177.74	74.06	88.13	24.14	0	1117.08	88.13	33.8	0	75	1603.07
4	Daniel Lee	Manager	2025-12-24	1561.67	187.4	78.08	92.92	25.46	0	1177.81	92.92	35.64	0	75	1690.23
6	Frank White	Seasonal Barista	2025-12-10	1247.15	149.66	62.36	74.21	20.33	0	940.6	74.21	28.46	179.52	0	1349.82
6	Frank White	Seasonal Barista	2025-12-24	1269.1	152.29	63.46	75.51	20.69	0	957.16	75.51	28.96	160.56	0	1373.57
1	Alice Johnson	Owner	2025-12-09	1930.83	231.7	96.54	114.88	31.47	0	1456.23	114.88	44.06	0	0	2089.77
1	Alice Johnson	Owner	2025-12-23	2026.49	243.18	101.32	120.58	33.03	0	1528.38	120.58	46.24	0	0	2193.31
2	Brian Smith	Barista	2025-12-09	1375.93	165.11	68.8	81.87	22.43	0	1037.72	81.87	31.4	284.5	0	1489.20
2	Brian Smith	Barista	2025-12-23	1324.6	158.95	66.23	78.81	21.59	0	999.01	78.81	30.23	240.29	0	1433.64
3	Chloe Davis	Barista	2025-12-09	1210.15	145.22	60.51	72	19.73	0	912.69	72	27.62	159.58	0	1309.77
3	Chloe Davis	Barista	2025-12-23	1248.37	149.8	62.42	74.28	20.35	0	941.52	74.28	28.49	165.18	0	1351.14
4	Daniel Lee	Manager	2025-12-09	1527.09	183.25	76.35	90.86	24.89	0	1151.73	90.86	34.85	0	75	1652.80
4	Daniel Lee	Manager	2025-12-23	1499.09	179.89	74.95	89.2	24.44	0	1130.61	89.2	34.21	0	75	1622.50
5	Eva Thompson	Independent Contractor	2025-12-09	1413.27	141.33	56.53	0	0	0	1215.42	0	0	0	0	1413.27
5	Eva Thompson	Independent Contractor	2025-12-23	1481.08	148.11	59.24	0	0	0	1273.73	0	0	0	0	1481.08
4	Daniel Lee	Manager	2025-10-01	1418.76	170.25	70.94	84.42	23.13	0	1070.03	84.42	32.38	0	75	1610.56
4	Daniel Lee	Manager	2025-10-15	1502.12	180.25	75.11	89.38	24.48	0	1132.9	89.38	34.28	0	75	1700.78
4	Daniel Lee	Manager	2025-10-29	1545.15	185.42	77.26	91.94	25.19	0	1165.36	91.94	35.26	0	75	1747.35
4	Daniel Lee	Manager	2025-11-13	1602.91	192.35	80.15	95.37	26.13	0	1208.91	95.37	36.58	0	75	1809.86
4	Daniel Lee	Manager	2025-11-27	1437.43	172.49	71.87	85.53	23.43	0	1084.11	85.53	32.8	0	75	1630.76
5	Eva Thompson	Independent Contractor	2025-08-04	1399.9	139.99	56	0	0	0	1203.91	0	0	0	0	1399.9
5	Eva Thompson	Independent Contractor	2025-08-18	1369.62	136.96	54.78	0	0	0	1177.87	0	0	0	0	1369.62
5	Eva Thompson	Independent Contractor	2025-09-04	1441.57	144.16	57.66	0	0	0	1239.75	0	0	0	0	1441.57
5	Eva Thompson	Independent Contractor	2025-09-18	1416.04	141.6	56.64	0	0	0	1217.79	0	0	0	0	1416.04
5	Eva Thompson	Independent Contractor	2025-10-01	1369.41	136.94	54.78	0	0	0	1177.69	0	0	0	0	1369.41
5	Eva Thompson	Independent Contractor	2025-10-15	1367.41	136.74	54.7	0	0	0	1175.98	0	0	0	0	1367.41
5	Eva Thompson	Independent Contractor	2025-10-29	1396.86	139.69	55.87	0	0	0	1201.3	0	0	0	0	1396.86
5	Eva Thompson	Independent Contractor	2025-11-13	1312.27	131.23	52.49	0	0	0	1128.55	0	0	0	0	1312.27
5	Eva Thompson	Independent Contractor	2025-11-27	1533.25	153.33	61.33	0	0	0	1318.6	0	0	0	0	1533.25
1	Alice Johnson	Owner	2025-08-04	2081.15	249.74	104.06	123.83	33.92	0	1569.6	123.83	47.49	0	0	2252.47
1	Alice Johnson	Owner	2025-08-18	1941.95	233.03	97.1	115.55	31.65	0	1464.62	115.55	44.32	0	0	2101.82
1	Alice Johnson	Owner	2025-09-04	1989.04	238.69	99.45	118.35	32.42	0	1500.14	118.35	45.39	0	0	2152.78
1	Alice Johnson	Owner	2025-09-18	1993.08	239.17	99.65	118.59	32.49	0	1503.18	118.59	45.48	0	0	2157.15
1	Alice Johnson	Owner	2025-10-01	1979.78	237.57	98.99	117.8	32.27	0	1493.15	117.8	45.18	0	0	2142.76
1	Alice Johnson	Owner	2025-10-15	2074.6	248.95	103.73	123.44	33.82	0	1564.66	123.44	47.34	0	0	2245.38
1	Alice Johnson	Owner	2025-10-29	2014.92	241.79	100.75	119.89	32.84	0	1519.65	119.89	45.98	0	0	2180.79
1	Alice Johnson	Owner	2025-11-13	1949.87	233.98	97.49	116.02	31.78	0	1470.59	116.02	44.5	0	0	2110.39
1	Alice Johnson	Owner	2025-11-27	1970.8	236.5	98.54	117.26	32.12	0	1486.37	117.26	44.97	0	0	2133.03
2	Brian Smith	Barista	2025-08-04	1291.57	154.99	64.58	76.85	21.05	0	974.1	76.85	29.47	221.29	0	1619.18
2	Brian Smith	Barista	2025-08-18	1311.85	157.42	65.59	78.05	21.38	0	989.39	78.05	29.94	197.41	0	1617.25
2	Brian Smith	Barista	2025-09-04	1241.02	148.92	62.05	73.84	20.23	0	935.98	73.84	28.32	185.24	0	1528.42
2	Brian Smith	Barista	2025-09-18	1307.07	156.85	65.35	77.77	21.31	0	985.79	77.77	29.83	190.81	0	1605.48
2	Brian Smith	Barista	2025-10-01	1382.18	165.86	69.11	82.24	22.53	0	1042.44	82.24	31.54	252.44	0	1748.40
2	Brian Smith	Barista	2025-10-15	1306.37	156.76	65.32	77.73	21.29	0	985.26	77.73	29.81	209.3	0	1623.21
2	Brian Smith	Barista	2025-10-29	1277.42	153.29	63.87	76.01	20.82	0	963.43	76.01	29.15	193.59	0	1576.17
2	Brian Smith	Barista	2025-11-13	1301.72	156.21	65.09	77.45	21.22	0	981.76	77.45	29.71	217.58	0	1626.46
2	Brian Smith	Barista	2025-11-27	1283.7	154.04	64.18	76.38	20.92	0	968.16	76.38	29.29	193.05	0	1582.42
3	Chloe Davis	Barista	2025-08-04	1294.04	155.28	64.7	77	21.09	0	975.96	77	29.53	141.74	0	1542.31
3	Chloe Davis	Barista	2025-08-18	1168.22	140.19	58.41	69.51	19.04	0	881.07	69.51	26.66	191.95	0	1456.34
3	Chloe Davis	Barista	2025-09-04	1299.76	155.97	64.99	77.34	21.19	0	980.28	77.34	29.66	223.38	0	1630.14
3	Chloe Davis	Barista	2025-09-18	1245.47	149.46	62.27	74.11	20.3	0	939.33	74.11	28.42	138.11	0	1486.11
3	Chloe Davis	Barista	2025-10-01	1251.77	150.21	62.59	74.48	20.4	0	944.09	74.48	28.57	188.12	0	1542.94
3	Chloe Davis	Barista	2025-10-15	1284.41	154.13	64.22	76.42	20.94	0	968.7	76.42	29.31	191.34	0	1581.48
3	Chloe Davis	Barista	2025-10-29	1284.5	154.14	64.22	76.43	20.94	0	968.77	76.43	29.31	218.22	0	1608.46
3	Chloe Davis	Barista	2025-11-13	1277.53	153.3	63.88	76.01	20.82	0	963.51	76.01	29.15	211.51	0	1594.20
3	Chloe Davis	Barista	2025-11-27	1203.63	144.44	60.18	71.62	19.62	0	907.78	71.62	27.47	152.94	0	1455.66
4	Daniel Lee	Manager	2025-08-04	1562.69	187.52	78.13	92.98	25.47	0	1178.58	92.98	35.66	0	75	1766.33
4	Daniel Lee	Manager	2025-08-18	1422.41	170.69	71.12	84.63	23.19	0	1072.78	84.63	32.46	0	75	1614.50
4	Daniel Lee	Manager	2025-09-04	1518.55	182.23	75.93	90.35	24.75	0	1145.29	90.35	34.65	0	75	1718.55
4	Daniel Lee	Manager	2025-09-18	1566.89	188.03	78.34	93.23	25.54	0	1181.75	93.23	35.76	0	75	1770.88
\.


--
-- Name: budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.budgets_id_seq', 179, true);


--
-- Name: company_budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_budgets_id_seq', 11, true);


--
-- Name: overall_budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.overall_budgets_id_seq', 57, true);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: company_budgets company_budgets_month_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_budgets
    ADD CONSTRAINT company_budgets_month_key UNIQUE (month);


--
-- Name: company_budgets company_budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_budgets
    ADD CONSTRAINT company_budgets_pkey PRIMARY KEY (id);


--
-- Name: employee_profiles employee_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_profiles
    ADD CONSTRAINT employee_profiles_pkey PRIMARY KEY (id);


--
-- Name: overall_budgets overall_budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.overall_budgets
    ADD CONSTRAINT overall_budgets_pkey PRIMARY KEY (id);


--
-- Name: payroll_history fk_employee_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_history
    ADD CONSTRAINT fk_employee_id FOREIGN KEY (employee_id) REFERENCES public.employee_profiles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict VIAgQ2Yul8z0mViYfTai29sLL7chxghfWqqLpLbMgGL5iREJIJX34xCoLiAYe8G

