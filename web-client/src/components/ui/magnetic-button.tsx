import { useRef, useEffect } from 'react';

interface MagneticButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /** Text or children inside the button */
  children: React.ReactNode;
}

/**
 * MagneticButton – a button that subtly follows the cursor, creating a magnetic attraction effect.
 * The effect uses CSS transform based on cursor position relative to the button's centre.
 * Supports any Tailwind classes passed via `className`.
 */
export default function MagneticButton({ children, className = '', ...rest }: MagneticButtonProps) {
  const btnRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    const btn = btnRef.current;
    if (!btn) return;

    const handleMouseMove = (e: MouseEvent) => {
      const rect = btn.getBoundingClientRect();
      const relX = e.clientX - rect.left - rect.width / 2; // distance from centre
      const relY = e.clientY - rect.top - rect.height / 2;
      // Scale down the movement for a subtle effect
      const moveX = (relX / rect.width) * 10; // max 10px shift
      const moveY = (relY / rect.height) * 10;
      btn.style.transform = `translate(${moveX}px, ${moveY}px)`;
    };
    const handleMouseLeave = () => {
      btn.style.transform = 'translate(0,0)';
    };
    // Attach listeners to the button element
    btn.addEventListener('mousemove', handleMouseMove);
    btn.addEventListener('mouseleave', handleMouseLeave);
    // Cleanup
    return () => {
      btn.removeEventListener('mousemove', handleMouseMove);
      btn.removeEventListener('mouseleave', handleMouseLeave);
    };
  }, []);

  return (
    <button
      ref={btnRef}
      className={`relative overflow-hidden transition-transform duration-200 ease-out ${className}`}
      {...rest}
    >
      {children}
    </button>
  );
}
