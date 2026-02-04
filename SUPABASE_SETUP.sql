-- ========================================
-- SUPABASE DATABASE SETUP - Complete
-- ========================================
-- Run this in your Supabase SQL Editor

-- ========================================
-- 1. FREELANCER_SIGNUPS TABLE
-- ========================================

-- Drop existing trigger and function if they exist (for clean setup)
DROP TRIGGER IF EXISTS check_freelancer_email_duplicate ON public.freelancer_signups;
DROP FUNCTION IF EXISTS check_freelancer_email_exists();

-- Create or update the freelancer_signups table
CREATE TABLE IF NOT EXISTS public.freelancer_signups (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  user_type text NOT NULL,
  experience text NOT NULL,
  superpower text,
  dream text,
  email text NOT NULL,
  whatsapp text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT freelancer_signups_pkey PRIMARY KEY (id),
  CONSTRAINT freelancer_signups_email_unique UNIQUE (email)
);

-- Enable Row Level Security
ALTER TABLE public.freelancer_signups ENABLE ROW LEVEL SECURITY;

-- Create Policy: Allow public to INSERT only
CREATE POLICY IF NOT EXISTS "Allow public to insert freelancer signups"
ON public.freelancer_signups
FOR INSERT
TO public
WITH CHECK (true);

-- Create function to check for duplicate email with custom error message
CREATE OR REPLACE FUNCTION check_freelancer_email_exists()
RETURNS TRIGGER AS $$
BEGIN
  -- Check if email already exists
  IF EXISTS (
    SELECT 1 FROM public.freelancer_signups 
    WHERE email = NEW.email
  ) THEN
    RAISE EXCEPTION 'You have already signed up with this email';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger that runs BEFORE INSERT
CREATE TRIGGER check_freelancer_email_duplicate
  BEFORE INSERT ON public.freelancer_signups
  FOR EACH ROW
  EXECUTE FUNCTION check_freelancer_email_exists();

-- ========================================
-- 2. NOTIFICATIONS TABLE
-- ========================================

-- Drop existing trigger and function if they exist
DROP TRIGGER IF EXISTS check_notification_email_duplicate ON public.notifications;
DROP FUNCTION IF EXISTS check_notification_email_exists();

-- Create or update the notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  email text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT notifications_email_unique UNIQUE (email)
);

-- Enable Row Level Security
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Create Policy: Allow public to INSERT only
CREATE POLICY IF NOT EXISTS "Allow public to insert notifications"
ON public.notifications
FOR INSERT
TO public
WITH CHECK (true);

-- Create function to check for duplicate email with custom error message
CREATE OR REPLACE FUNCTION check_notification_email_exists()
RETURNS TRIGGER AS $$
BEGIN
  -- Check if email already exists
  IF EXISTS (
    SELECT 1 FROM public.notifications 
    WHERE email = NEW.email
  ) THEN
    RAISE EXCEPTION 'You have already signed up with this email';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger that runs BEFORE INSERT
CREATE TRIGGER check_notification_email_duplicate
  BEFORE INSERT ON public.notifications
  FOR EACH ROW
  EXECUTE FUNCTION check_notification_email_exists();

-- ========================================
-- 3. CONTACT_MESSAGES TABLE
-- ========================================

-- Drop existing trigger and function if they exist
DROP TRIGGER IF EXISTS check_contact_email_duplicate ON public.contact_messages;
DROP FUNCTION IF EXISTS check_contact_email_exists();

-- Create or update the contact_messages table
CREATE TABLE IF NOT EXISTS public.contact_messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  message text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT contact_messages_pkey PRIMARY KEY (id),
  CONSTRAINT contact_messages_email_unique UNIQUE (email)
);

-- Enable Row Level Security
ALTER TABLE public.contact_messages ENABLE ROW LEVEL SECURITY;

-- Create Policy: Allow public to INSERT only
CREATE POLICY IF NOT EXISTS "Allow public to insert messages"
ON public.contact_messages
FOR INSERT
TO public
WITH CHECK (true);

-- Create function to check for duplicate email with custom error message
CREATE OR REPLACE FUNCTION check_contact_email_exists()
RETURNS TRIGGER AS $$
BEGIN
  -- Check if email already exists
  IF EXISTS (
    SELECT 1 FROM public.contact_messages 
    WHERE email = NEW.email
  ) THEN
    RAISE EXCEPTION 'You have already signed up with this email';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger that runs BEFORE INSERT
CREATE TRIGGER check_contact_email_duplicate
  BEFORE INSERT ON public.contact_messages
  FOR EACH ROW
  EXECUTE FUNCTION check_contact_email_exists();

-- ========================================
-- VERIFICATION QUERIES
-- ========================================
-- Run these to verify the setup worked:

-- Check if tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('freelancer_signups', 'notifications', 'contact_messages');

-- Check unique constraints
SELECT tc.table_name, tc.constraint_name, tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'public'
  AND tc.constraint_type = 'UNIQUE'
  AND tc.table_name IN ('freelancer_signups', 'notifications', 'contact_messages');

-- Check triggers
SELECT trigger_name, event_object_table, action_timing, event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
  AND event_object_table IN ('freelancer_signups', 'notifications', 'contact_messages');
