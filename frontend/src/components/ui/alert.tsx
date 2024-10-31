import * as React from "react"

interface AlertProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: 'default' | 'destructive';
}

const Alert = React.forwardRef<HTMLDivElement, AlertProps>(
  ({ className = '', variant = 'default', ...props }, ref) => {
    const baseStyles = "relative w-full rounded-lg border p-4"
    const variantStyles = variant === 'destructive' 
      ? "border-red-500/50 text-red-500 bg-red-500/10" 
      : "bg-gray-100 border-gray-200 text-gray-900"

    return (
      <div
        ref={ref}
        role="alert"
        className={`${baseStyles} ${variantStyles} ${className}`}
        {...props}
      />
    )
  }
)
Alert.displayName = "Alert"

const AlertDescription = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLParagraphElement>
>(({ className = '', ...props }, ref) => (
  <div
    ref={ref}
    className={`text-sm leading-relaxed ${className}`}
    {...props}
  />
))
AlertDescription.displayName = "AlertDescription"

export { Alert, AlertDescription } 