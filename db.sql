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
-- Name: create_incomings(integer, character varying, double precision, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_incomings(_user_id integer, _name_inc character varying, _total double precision, _inc_date timestamp without time zone, _created_date timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _res_id INTEGER;

BEGIN 

INSERT INTO incomings VALUES (default, _user_id, _name_inc, _total, _inc_date, _created_date, _created_date, _created_date)
RETURNING incomings.id 
INTO _res_id; 
RETURN _res_id AS id;

END $$;


ALTER FUNCTION public.create_incomings(_user_id integer, _name_inc character varying, _total double precision, _inc_date timestamp without time zone, _created_date timestamp without time zone) OWNER TO postgres;

--
-- Name: create_item(integer, character varying, integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_item(_check_id integer, _name character varying, _price integer, _quantity integer, _created_date timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _res_id INTEGER;

BEGIN 

INSERT INTO item VALUES (default, _check_id, _name, _price, _quantity, _created_date, _created_date, _created_date)
RETURNING item.id 
INTO _res_id; 
RETURN _res_id AS id;

END $$;


ALTER FUNCTION public.create_item(_check_id integer, _name character varying, _price integer, _quantity integer, _created_date timestamp without time zone) OWNER TO postgres;

--
-- Name: create_items(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_items(_check_id integer, _items_values character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
    execute 'insert into items VALUES ' || _items_values || ;
end;
$$;


ALTER FUNCTION public.create_items(_check_id integer, _items_values character varying) OWNER TO postgres;

--
-- Name: create_qr_check(integer, character varying, timestamp without time zone, timestamp without time zone, double precision, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_qr_check(_user_id integer, _check_name character varying, _check_date timestamp without time zone, _created_date timestamp without time zone, _totalsum double precision, _deleted_date timestamp without time zone, _updated_date timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _res_id INTEGER;

BEGIN 

INSERT INTO qr_check VALUES (default, _user_id, _check_name, _check_date, _created_date, _totalsum, _deleted_date, _updated_date)
RETURNING qr_check.id 
INTO _res_id; 
RETURN _res_id AS id;

END $$;


ALTER FUNCTION public.create_qr_check(_user_id integer, _check_name character varying, _check_date timestamp without time zone, _created_date timestamp without time zone, _totalsum double precision, _deleted_date timestamp without time zone, _updated_date timestamp without time zone) OWNER TO postgres;

--
-- Name: create_test(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_test(_test_values text) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
    execute 'insert into (id, name) test VALUES '  || _test_values || ';';
end;
$$;


ALTER FUNCTION public.create_test(_test_values text) OWNER TO postgres;

--
-- Name: create_user(character varying, character varying, character varying, character varying, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user(_username character varying, _password_hash character varying, _phone character varying, _email character varying, _created_date timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE _res_id INTEGER;

BEGIN 

INSERT INTO users VALUES (default, _username, _password_hash, _phone, _email, _created_date, _created_date, _created_date, 0)
RETURNING users.id 
INTO _res_id; 
RETURN _res_id AS id;

END $$;


ALTER FUNCTION public.create_user(_username character varying, _password_hash character varying, _phone character varying, _email character varying, _created_date timestamp without time zone) OWNER TO postgres;

--
-- Name: delete_incomings(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_incomings(_incomings_id integer, _user_id integer, _deleted_date timestamp without time zone) RETURNS TABLE(id integer, deleted_date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return query
	UPDATE incomings SET deleted_date = _deleted_date WHERE incomings.id = _incomings_id AND incomings.user_id = _user_id RETURNING incomings.id,incomings.deleted_date;
END; 
$$;


ALTER FUNCTION public.delete_incomings(_incomings_id integer, _user_id integer, _deleted_date timestamp without time zone) OWNER TO postgres;

--
-- Name: delete_item(integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_item(_item_id integer, _deleted_date timestamp without time zone) RETURNS TABLE(id integer, deleted_date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return query
	UPDATE item SET deleted_date = _deleted_date WHERE item.id = _item_id RETURNING item.id, item.deleted_date;
END; 
$$;


ALTER FUNCTION public.delete_item(_item_id integer, _deleted_date timestamp without time zone) OWNER TO postgres;

--
-- Name: delete_qr_check(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_qr_check(_qr_check_id integer, _user_id integer, _deleted_date timestamp without time zone) RETURNS TABLE(id integer, deleted_date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return query
	UPDATE qr_check SET deleted_date = _deleted_date WHERE qr_check.id = _qr_check_id AND qr_check.user_id = _user_id RETURNING qr_check.id, qr_check.deleted_date;
END; 
$$;


ALTER FUNCTION public.delete_qr_check(_qr_check_id integer, _user_id integer, _deleted_date timestamp without time zone) OWNER TO postgres;

--
-- Name: get_check_id(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_check_id(_check_id integer, _user_id integer) RETURNS TABLE(id integer, check_name text, check_date timestamp without time zone, created_date timestamp without time zone, totalsum double precision)
    LANGUAGE sql
    AS $$
SELECT id, check_name, check_date, created_date, totalsum FROM qr_check WHERE qr_check.id = _check_id AND qr_check.user_id = _user_id AND qr_check.deleted_date = qr_check.created_date; 
$$;


ALTER FUNCTION public.get_check_id(_check_id integer, _user_id integer) OWNER TO postgres;

--
-- Name: get_checks_current_user(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_checks_current_user(_id integer, _limit integer, _offset integer) RETURNS TABLE(id integer, check_name text, check_date timestamp without time zone, created_date timestamp without time zone, totalsum double precision)
    LANGUAGE sql
    AS $$
SELECT id, check_name, check_date, created_date, totalsum FROM qr_check WHERE qr_check.user_id = _id AND qr_check.deleted_date = qr_check.created_date LIMIT _limit OFFSET _offset; 
$$;


ALTER FUNCTION public.get_checks_current_user(_id integer, _limit integer, _offset integer) OWNER TO postgres;

--
-- Name: get_finance_user_id(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_finance_user_id(_id integer, now_date character varying) RETURNS TABLE(incomings character varying, costs character varying, balance character varying)
    LANGUAGE sql
    AS $$ 
select 
	(SELECT CAST(SUM(incomings.total) as varchar) as incomings FROM incomings WHERE incomings.user_id = _id and incomings.inc_date > (select TO_TIMESTAMP (now_date, 'YYYY-MM-01 00:00:00')::TIMESTAMP) ),
	(SELECT CAST(SUM(qr_check.totalsum) as varchar) as costs FROM qr_check WHERE qr_check.user_id = _id and qr_check.check_date > (select TO_TIMESTAMP (now_date, 'YYYY-MM-01 00:00:00')::TIMESTAMP)),
	(SELECT CAST(balance as varchar) FROM users WHERE users.id = _id);
$$;


ALTER FUNCTION public.get_finance_user_id(_id integer, now_date character varying) OWNER TO postgres;

--
-- Name: get_incomings(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_incomings(_user_id integer, _limit integer, _offset integer) RETURNS TABLE(id integer, name_inc character varying, total double precision, inc_date timestamp without time zone, created_date timestamp without time zone, updated_date timestamp without time zone, deleted_date timestamp without time zone)
    LANGUAGE sql
    AS $$
SELECT id, name_inc, total, inc_date,created_date,updated_date,deleted_date FROM incomings WHERE incomings.user_id = _user_id 
ORDER BY updated_date DESC
limit _limit offset _offset; 
$$;


ALTER FUNCTION public.get_incomings(_user_id integer, _limit integer, _offset integer) OWNER TO postgres;

--
-- Name: get_incomings_id(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_incomings_id(_incomings_id integer, _user_id integer) RETURNS TABLE(id integer, name_inc character varying, total double precision, inc_date timestamp without time zone, created_date timestamp without time zone, updated_date timestamp without time zone, deleted_date timestamp without time zone)
    LANGUAGE sql
    AS $$
SELECT id, name_inc, total, inc_date,created_date,updated_date,deleted_date FROM incomings WHERE incomings.id = _incomings_id AND incomings.user_id = _user_id; 
$$;


ALTER FUNCTION public.get_incomings_id(_incomings_id integer, _user_id integer) OWNER TO postgres;

--
-- Name: get_item_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_item_id(_id integer) RETURNS TABLE(id integer, name character varying, price integer, quantity integer, created_date timestamp without time zone, updated_date timestamp without time zone, deleted_date timestamp without time zone)
    LANGUAGE sql
    AS $$ 
SELECT item.id, item.name, item.price, item.quantity, item.created_date, item.updated_date, item.deleted_date FROM item WHERE item.id = _id;
$$;


ALTER FUNCTION public.get_item_id(_id integer) OWNER TO postgres;

--
-- Name: get_items_definite_check(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_items_definite_check(_id integer) RETURNS TABLE(id integer, name character varying, price integer, quantity integer, created_date timestamp without time zone, updated_date timestamp without time zone, deleted_date timestamp without time zone)
    LANGUAGE sql
    AS $$ 
SELECT item.id, item.name, item.price, item.quantity, item.created_date, item.updated_date, item.deleted_date FROM item WHERE item.check_id = _id AND item.deleted_date = item.created_date;
$$;


ALTER FUNCTION public.get_items_definite_check(_id integer) OWNER TO postgres;

--
-- Name: get_user_email(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_email(_email character varying) RETURNS TABLE(id integer, username character varying, password_hash character varying, phone character varying, email character varying)
    LANGUAGE sql
    AS $$ 
SELECT id, username, password_hash, phone, email FROM users WHERE users.email = _email;
$$;


ALTER FUNCTION public.get_user_email(_email character varying) OWNER TO postgres;

--
-- Name: get_user_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_id(_id integer) RETURNS TABLE(id integer, username character varying, password_hash character varying, phone character varying, email character varying, balance double precision)
    LANGUAGE sql
    AS $$ 
SELECT id, username, password_hash, phone, email, balance FROM users WHERE users.id = _id;
$$;


ALTER FUNCTION public.get_user_id(_id integer) OWNER TO postgres;

--
-- Name: incomings_balance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.incomings_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   DECLARE _balance integer;
   BEGIN   
	   _balance = (SELECT balance from users WHERE users.id = NEW.user_id);  
      
        IF (TG_OP = 'INSERT') THEN
            UPDATE users SET balance = _balance + NEW.total WHERE users.id = NEW.user_id;
            RETURN NEW;
        ELSIF (TG_OP = 'UPDATE') THEN
	    	 IF (NEW.deleted_date > OLD.deleted_date) THEN
	            UPDATE users SET balance = _balance-OLD.total WHERE users.id = NEW.user_id;
	            RETURN NEW;
        	 ELSE
	            UPDATE users SET balance = _balance-OLD.total+NEW.total WHERE users.id = NEW.user_id;	            RETURN NEW;
	       	 END IF;            
        END IF;
        RETURN NULL; 
      RETURN NEW;
   END;
$$;


ALTER FUNCTION public.incomings_balance() OWNER TO postgres;

--
-- Name: insert_all(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_all(_check_id integer, _data text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
EXECUTE 'INSERT INTO item SELECT * FROM unnest('|| quote_ident(_data) ||')';
END
$$;


ALTER FUNCTION public.insert_all(_check_id integer, _data text) OWNER TO postgres;

--
-- Name: insert_test(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_test(_data text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
EXECUTE 'INSERT INTO test SELECT * FROM unnest('|| quote_ident(_data) ||')';
END
$$;


ALTER FUNCTION public.insert_test(_data text) OWNER TO postgres;

--
-- Name: item_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.item_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   DECLARE _totalsum integer;
   BEGIN   
	   _totalsum = (SELECT totalsum from qr_check WHERE qr_check.id = NEW.check_id);  
      
        IF (TG_OP = 'INSERT') THEN
            UPDATE qr_check SET totalsum = _totalsum + NEW.price, updated_date = NEW.updated_date WHERE qr_check.id = NEW.check_id;
            RETURN NEW;
        ELSIF (TG_OP = 'UPDATE') THEN            
            UPDATE qr_check SET totalsum = _totalsum - OLD.price + NEW.price,updated_date = NEW.updated_date WHERE qr_check.id = NEW.check_id;
            RETURN NEW;    
        END IF;
        RETURN NULL; 
      RETURN NEW;
   END;
$$;


ALTER FUNCTION public.item_price() OWNER TO postgres;

--
-- Name: qr_check_balance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.qr_check_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   DECLARE _balance integer;
   BEGIN     
        IF (TG_OP = 'UPDATE') THEN
        	_balance = (SELECT balance from users WHERE users.id = NEW.user_id);
        	IF (NEW.deleted_date > OLD.deleted_date) THEN
	            UPDATE users SET balance = _balance - OLD.totalsum, deleted_date = NEW.deleted_date WHERE users.id = NEW.user_id;
	            RETURN NEW;
        	 ELSE
        	 	 UPDATE users SET balance = _balance - NEW.totalsum + OLD.totalsum, updated_date = NEW.updated_date WHERE users.id = NEW.user_id;
	            RETURN NEW;
	       	 END IF;               
        ELSIF (TG_OP = 'INSERT') THEN
            _balance = (SELECT balance from users WHERE users.id = NEW.user_id);
            UPDATE users SET balance = _balance - NEW.totalsum, updated_date = NEW.updated_date WHERE users.id = NEW.user_id;
            RETURN NEW;             
        END IF;
        RETURN NULL; 
      RETURN NEW;
   END;
$$;


ALTER FUNCTION public.qr_check_balance() OWNER TO postgres;

--
-- Name: update_incomings(integer, integer, character varying, double precision, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_incomings(_incomings_id integer, _user_id integer, _name_inc character varying, _total double precision, _inc_date timestamp without time zone, _updated_date timestamp without time zone) RETURNS TABLE(id integer, user_id integer, name_inc character varying, total double precision, inc_date timestamp without time zone, created_date timestamp without time zone, updated_date timestamp without time zone, deleted_date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return query
	UPDATE incomings SET name_inc=_name_inc, total = _total, inc_date = _inc_date, updated_date = _updated_date WHERE incomings.id = _incomings_id AND incomings.user_id = _user_id RETURNING incomings.id , incomings.user_id, incomings.name_inc , incomings.total , incomings.inc_date, incomings.created_date , incomings.updated_date, incomings.deleted_date;
END; 
$$;


ALTER FUNCTION public.update_incomings(_incomings_id integer, _user_id integer, _name_inc character varying, _total double precision, _inc_date timestamp without time zone, _updated_date timestamp without time zone) OWNER TO postgres;

--
-- Name: update_item(integer, character varying, integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_item(_item_id integer, _name character varying, _price integer, _quantity integer, _updated_date timestamp without time zone) RETURNS TABLE(id integer, check_id integer, name character varying, price integer, quantity integer, created_date timestamp without time zone, updated_date timestamp without time zone, deleted_date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return query
	UPDATE item SET name=_name, price = _price, quantity = _quantity, updated_date = _updated_date WHERE item.id = _item_id 
	RETURNING item.id, item.check_id, item.name, item.price, item.quantity, item.created_date , item.updated_date , item.deleted_date;
END; 
$$;


ALTER FUNCTION public.update_item(_item_id integer, _name character varying, _price integer, _quantity integer, _updated_date timestamp without time zone) OWNER TO postgres;

--
-- Name: update_qr_check(integer, integer, character varying, timestamp without time zone, double precision, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_qr_check(_check_id integer, _user_id integer, _check_name character varying, _check_date timestamp without time zone, _totalsum double precision, _updated_date timestamp without time zone) RETURNS TABLE(id integer, user_id integer, check_name character varying, check_date timestamp without time zone, created_date timestamp without time zone, totalsum double precision, deleted_date timestamp without time zone, updated_date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return query
	UPDATE qr_check SET check_name=_check_name, check_date = _check_date, totalsum = _totalsum, updated_date = _updated_date WHERE qr_check.id = _check_id AND 	qr_check.user_id = _user_id RETURNING qr_check.id, qr_check.user_id, qr_check.check_name, qr_check.check_date, qr_check.created_date, qr_check.totalsum, qr_check.deleted_date, qr_check.updated_date;
END; 
$$;


ALTER FUNCTION public.update_qr_check(_check_id integer, _user_id integer, _check_name character varying, _check_date timestamp without time zone, _totalsum double precision, _updated_date timestamp without time zone) OWNER TO postgres;

--
-- Name: update_users(integer, character varying, character varying, character varying, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_users(_user_id integer, _username character varying, _phone character varying, _email character varying, _updated_date timestamp without time zone) RETURNS TABLE(id integer, username character varying, phone character varying, email character varying, updated_date timestamp without time zone, balance double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return query
	UPDATE users SET username=_username, phone = _phone, email = _email, updated_date = _updated_date WHERE users.id = _user_id RETURNING users.id, users.username, users.phone, users.email, users.updated_date, users.balance;
END; 
$$;


ALTER FUNCTION public.update_users(_user_id integer, _username character varying, _phone character varying, _email character varying, _updated_date timestamp without time zone) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: incomings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incomings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name_inc character varying(100),
    total double precision,
    inc_date timestamp without time zone,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    deleted_date timestamp without time zone
);


ALTER TABLE public.incomings OWNER TO postgres;

--
-- Name: incomings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incomings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.incomings_id_seq OWNER TO postgres;

--
-- Name: incomings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incomings_id_seq OWNED BY public.incomings.id;


--
-- Name: incomings_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incomings_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.incomings_user_id_seq OWNER TO postgres;

--
-- Name: incomings_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incomings_user_id_seq OWNED BY public.incomings.user_id;


--
-- Name: item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item (
    id integer NOT NULL,
    check_id integer NOT NULL,
    name character varying(100),
    price integer,
    quantity integer,
    deleted_date timestamp without time zone,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
);


ALTER TABLE public.item OWNER TO postgres;

--
-- Name: item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_id_seq OWNER TO postgres;

--
-- Name: item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_id_seq OWNED BY public.item.id;


--
-- Name: qr_check; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qr_check (
    id integer NOT NULL,
    user_id integer NOT NULL,
    check_name character varying(200),
    check_date timestamp without time zone,
    created_date timestamp without time zone,
    totalsum double precision,
    deleted_date timestamp without time zone,
    updated_date timestamp without time zone
);


ALTER TABLE public.qr_check OWNER TO postgres;

--
-- Name: qr_check_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qr_check_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qr_check_id_seq OWNER TO postgres;

--
-- Name: qr_check_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qr_check_id_seq OWNED BY public.qr_check.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50),
    password_hash character varying(100),
    phone character varying(20),
    email character varying(100),
    deleted_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_date timestamp without time zone,
    balance double precision
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
-- Name: incomings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incomings ALTER COLUMN id SET DEFAULT nextval('public.incomings_id_seq'::regclass);


--
-- Name: incomings user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incomings ALTER COLUMN user_id SET DEFAULT nextval('public.incomings_user_id_seq'::regclass);


--
-- Name: item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item ALTER COLUMN id SET DEFAULT nextval('public.item_id_seq'::regclass);


--
-- Name: qr_check id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_check ALTER COLUMN id SET DEFAULT nextval('public.qr_check_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: incomings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incomings (id, user_id, name_inc, total, inc_date, created_date, updated_date, deleted_date) FROM stdin;
2	1	ЗП	145.5	2019-02-02 03:32:15.253645	2019-02-02 03:32:15.253645	2019-02-02 03:32:15.253645	2019-02-02 03:32:15.253645
3	1	ЗП	145.5	2019-02-12 09:24:41.357895	2019-02-12 09:24:41.357895	2019-02-12 09:24:41.357895	2019-02-12 09:24:41.357895
4	1	ЗП	145.5	2019-02-12 09:24:50.613311	2019-02-12 09:24:50.613311	2019-02-12 09:24:50.613311	2019-02-12 09:24:50.613311
5	1	ЗП	145.5	2019-02-12 10:25:03.902283	2019-02-12 10:25:03.902283	2019-02-12 10:25:03.902283	2019-02-12 10:25:03.902283
6	1	ЗП	145.5	2019-02-12 10:27:10.481911	2019-02-12 10:27:10.481911	2019-02-12 10:27:10.481911	2019-02-12 10:27:10.481911
7	1	ЗП	145.5	2019-02-12 10:27:51.573638	2019-02-12 10:27:51.573638	2019-02-12 10:27:51.573638	2019-02-12 10:27:51.573638
8	1	ЗП	145.5	2019-02-12 10:29:06.540126	2019-02-12 10:29:06.540126	2019-02-12 10:29:06.540126	2019-02-12 10:29:06.540126
9	1	ЗП	145.5	2019-02-12 10:30:25.83872	2019-02-12 10:30:25.83872	2019-02-12 10:30:25.83872	2019-02-12 10:30:25.83872
10	1	ЗП	145.5	2019-02-12 10:30:48.556457	2019-02-12 10:30:48.556457	2019-02-12 10:30:48.556457	2019-02-12 10:30:48.556457
11	1	хач	14000	2015-02-01 13:19:13	2015-02-01 13:19:13	2015-02-01 13:19:13	2015-02-01 13:19:13
1	1	ЗП	400	2019-02-02 03:31:11.232536	2019-02-02 03:31:11.232536	2019-02-02 03:39:03.112749	2019-02-12 03:31:11.232536
12	1	жир	200	2019-02-15 00:06:00	2019-02-15 00:05:00	2019-02-15 00:15:00	2019-02-15 00:23:00
13	1	жир	200	2019-02-15 00:05:00	2019-02-15 00:05:00	2019-02-15 00:05:00	2019-02-15 00:05:00
14	1	жир	200	2019-02-15 00:05:00	2019-02-15 00:05:00	2019-02-15 00:05:00	2019-02-15 00:05:00
15	1	ЗП	20000	2019-02-15 00:05:00	2019-02-15 00:05:00	2019-02-15 00:05:00	2019-02-15 00:05:00
16	1	ЗП	20000	2019-02-15 00:05:00	2019-02-15 00:05:00	2019-02-15 00:05:00	2019-02-15 00:05:00
18	1	hi	100	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00
19	1	rty	100	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00
20	1	gyrrr	1000	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00
21	1	dddffffffffffd	100000	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00
22	1	534	134	2019-02-19 15:48:05	2019-02-19 12:00:00	2019-02-19 12:00:00	2019-02-19 12:00:00
23	1	зпэха	100000	2019-02-19 15:50:50	2019-02-19 15:50:50	2019-02-19 15:50:50	2019-02-19 15:50:50
24	1	hahaha	1000	2019-02-19 15:54:36	2019-02-19 15:54:36	2019-02-19 15:54:36	2019-02-19 15:54:36
25	1	перевод от Лехи	250	2019-02-20 02:35:17	2019-02-20 02:35:17	2019-02-20 02:35:17	2019-02-20 02:35:17
26	4	зарплата	100	2019-02-20 10:22:33	2019-02-20 10:22:33	2019-02-20 10:22:33	2019-02-20 10:22:33
27	10	зарплата 	100	2019-02-20 10:29:54	2019-02-20 10:29:54	2019-02-20 10:29:54	2019-02-20 10:29:54
28	10	зарплата	8000	2019-02-21 00:25:06	2019-02-21 00:25:06	2019-02-21 00:25:06	2019-02-21 00:25:06
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item (id, check_id, name, price, quantity, deleted_date, created_date, updated_date) FROM stdin;
50	96	 хлеб	20	1	2019-02-20 02:28:03	2019-02-20 02:28:03	2019-02-20 02:28:03
51	96	молоко	25	1	2019-02-20 02:28:03	2019-02-20 02:28:03	2019-02-20 02:28:03
52	100	хлеб 	25	1	2019-02-20 10:28:48	2019-02-20 10:28:48	2019-02-20 10:28:48
53	100	молоко	30	1	2019-02-20 10:28:48	2019-02-20 10:28:48	2019-02-20 10:28:48
56	101	Яблоки	56	4	2019-02-20 23:34:56	2019-02-20 23:34:56	2019-02-21 00:21:43
55	101	Фруктовый чай	50	2	2019-02-20 23:34:56	2019-02-20 23:34:56	2019-02-21 00:24:28
57	101	Сухарики 3 корочки	26	1	2019-02-20 23:34:56	2019-02-20 23:34:56	2019-02-21 00:24:37
54	101	сидр 	60	1	2019-02-21 00:32:56	2019-02-20 23:34:56	2019-02-21 00:08:02
58	102	хлеб	20	1	2019-02-21 00:44:04	2019-02-21 00:44:04	2019-02-21 00:44:04
59	102	чай липтон	102	1	2019-02-21 00:44:04	2019-02-21 00:44:04	2019-02-21 00:44:11
\.


--
-- Data for Name: qr_check; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qr_check (id, user_id, check_name, check_date, created_date, totalsum, deleted_date, updated_date) FROM stdin;
96	1	hi	2019-02-20 02:28:03	2019-02-20 02:28:03	55	2019-02-20 02:28:03	2019-02-20 02:28:03
97	1	Нижний магазин	2019-02-20 02:33:35	2019-02-20 02:33:35	300	2019-02-20 02:33:35	2019-02-20 02:33:35
98	4	МАК1	2019-02-11 16:22:00	2019-02-11 16:22:00	300	2019-02-11 16:22:00	2019-02-11 16:22:00
99	4	МАК1	2019-02-11 16:22:00	2019-02-11 16:22:00	300	2019-02-11 16:22:00	2019-02-11 16:22:00
101	10	Нижний магазин	2019-02-20 23:34:56	2019-02-20 23:34:56	192	2019-02-20 23:34:56	2019-02-21 00:08:02
100	10	Покупка еды в нижнем магазине	2019-02-20 10:28:48	2019-02-20 10:28:48	55	2019-02-21 00:28:48	2019-02-20 10:28:48
102	10	пятерочка	2019-02-21 00:44:04	2019-02-21 00:44:04	122	2019-02-21 00:53:17	2019-02-21 00:44:11
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password_hash, phone, email, deleted_date, updated_date, created_date, balance) FROM stdin;
10	володя	sha256$RXkw5MUk$0eabfac5d386051a28ace74ad718577a04473184c46d80bdeda292c11607dc17	89922138049	vol@gmail.com	2019-02-21 00:53:17	2019-02-21 00:44:11	2019-02-20 10:24:38	7554
1	Савелий	sha256$VF74XVPO$7583b55e5a3491b362914d07de5408ef1785d92cb232fa2e94444489f4a389e7	+799632566	sabellusbiz@yandex.ru	2019-02-12 23:13:04.180462	2019-02-20 02:33:35	\N	203248
7	sava	sha256$oWlt7Dn2$b09164d9814f92113cd1c449830989a53a6ce9582ba137959fb5a7f074fc6994	+79922138049	sdfsdgsd@gmal.com	2019-02-20 06:38:32	2019-02-20 06:38:32	2019-02-20 06:38:32	0
8	Savadsf	sha256$woAWmsRV$1453f29eab34bfbc1968ea539d5ad0a4c52e5f144c7b83cbf92ba4247405112a	+79922138049	sdfsdgsd@	2019-02-20 06:41:30	2019-02-20 06:41:30	2019-02-20 06:41:30	0
9	Savadsf	sha256$VQY3IX4n$925e745f37ad104f9383f5be6411bf7e03a8dfc657ec0a634b8d20afde40762d	+79922138049	sdfsdgsd@35445	2019-02-20 06:42:29	2019-02-20 06:42:29	2019-02-20 06:42:29	0
5	Иван	sha256$fMo64tH0$6914a658196e4f01a8675ae18fbe0b58d4562580953ebcd8e883c4073ef095d2	+799632566	nakazan.ru@gmail.co	\N	\N	\N	0
6	Иван	sha256$JpGm5Pal$9695b6facb6859d8038c0427d810bb944b1eb172e947489e961229b9cf89d7b4	+799632566	nakazan.ru@gmail.c	\N	\N	\N	0
4	Иван	sha256$WB6wbbJY$d00aedae8d0f7b5acf507baf29887fb589a61ade0564728f6064190848fac916	+799632566	nakazan.ru@gmail.com	\N	2019-02-11 16:22:00	\N	0
\.


--
-- Name: incomings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incomings_id_seq', 28, true);


--
-- Name: incomings_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incomings_user_id_seq', 1, true);


--
-- Name: item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_id_seq', 59, true);


--
-- Name: qr_check_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.qr_check_id_seq', 102, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 10, true);


--
-- Name: incomings incomings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incomings
    ADD CONSTRAINT incomings_pkey PRIMARY KEY (id);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (id);


--
-- Name: qr_check qr_check_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_check
    ADD CONSTRAINT qr_check_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: incomings incomings_balance; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER incomings_balance AFTER INSERT OR UPDATE ON public.incomings FOR EACH ROW EXECUTE PROCEDURE public.incomings_balance();


--
-- Name: item item_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER item_price BEFORE INSERT OR UPDATE ON public.item FOR EACH ROW EXECUTE PROCEDURE public.item_price();


--
-- Name: qr_check qr_check_balance; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER qr_check_balance AFTER INSERT OR UPDATE ON public.qr_check FOR EACH ROW EXECUTE PROCEDURE public.qr_check_balance();


--
-- PostgreSQL database dump complete
--

