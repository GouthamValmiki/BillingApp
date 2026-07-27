# 🌿 AgriBill — Neumorphic UI Redesign

## Overview

Complete UI redesign of the BillingApp for fertilizer & seed shops, transformed from a basic SwiftUI interface into a stunning **Neumorphic / Soft UI** design system.

---

## 🆕 New File Added

### `NeumorphicDesign.swift` (458 lines)
A complete **Neumorphic Design System** with reusable components:

| Component | Description |
|-----------|-------------|
| `NeuTheme` | Design tokens — colors, shadows, spacing, gradients |
| `NeuRaised` | Raised/embossed shadow modifier |
| `NeuPressed` | Pressed/debossed shadow modifier |
| `NeuInset` | Inset shadow modifier (for inputs) |
| `NeuCard` | Soft raised card container |
| `NeuInsetCard` | Inset card for inputs/fields |
| `NeuButton` | Gradient button with press animation |
| `NeuSoftButton` | Base-color soft button with neumorphic shadow |
| `NeuTextField` | Inset text field with icon support |
| `NeuCircleIcon` | Neumorphic circular icon badge |
| `NeuFab` | Floating Action Button with rotation animation |
| `NeuSearchBar` | Inset search bar with clear button |
| `NeuSectionHeader` | Uppercase section header with icon |
| `NeuBadge` | Pill-shaped colored badge |
| `NeuDivider` | Neumorphic divider with soft shadows |

---

## 📝 Files Modified

### `ContentView.swift` (303 lines)
**Before:** Plain NavigationView + List with default Form sheet
**After:**
- Custom neumorphic header with app logo & title
- Animated search bar (toggle with search icon)
- Live stats pills (Customers, With Credit, Settled)
- Neumorphic customer cards with avatar initials, credit badges
- Floating Action Button (FAB) for adding customers
- Beautiful empty state with illustration
- Neumorphic add-customer sheet with custom text fields

### `CustomerDetailView.swift` (285 lines)
**Before:** Simple ScrollView with basic green card and plain buttons
**After:**
- Neumorphic profile card with avatar, name, phone
- Animated credit balance counter (spring animation)
- Gradient action buttons (Bill / Payment)
- Quick stats row (Total Billed, Paid, Bills Count)
- Neumorphic transaction ledger with icon-based rows
- Empty state for no transactions

### `CreateBillView.swift` (499 lines)
**Before:** Plain Form with Picker and basic list
**After:**
- Custom header with item count badge
- Neumorphic product selection with Menu picker
- Category filter pills (All / Seed / Fertilizer)
- Quick-add product grid with selection highlight
- Cart items section with remove capability
- Bill summary card with inset payment field
- Sticky bottom action bar (Cancel / Save & Print)

### `PrintManager.swift` (162 lines)
**Before:** Basic HTML template with minimal styling
**After:**
- Professional styled invoice with:
  - Centered header with leaf emoji
  - Customer info card with left border accent
  - Invoice number (auto-generated)
  - Dashed-border items section
  - Green gradient total section
  - Footer with thank-you message
  - Watermark

---

## 🎨 Design System Tokens

| Token | Value |
|-------|-------|
| Base Color | `#E6E7EA` (soft gray) |
| Green Accent | `#2E7D32` (agricultural green) |
| Blue Accent | `#2255A8` (payment blue) |
| Red Accent | `#C62828` (credit/debt red) |
| Orange Accent | `#E67D22` (fertilizer orange) |
| Shadow Light | White at 70% opacity |
| Shadow Dark | Black at 18% opacity |
| Shadow Radius | 8pt |
| Shadow Offset | 6pt |
| Corner Radius | 16pt (default), 10pt (small), 24pt (large) |

---

## ✨ Unique UI Features

1. **Neumorphic Soft Shadows** — Every element has dual shadows (light top-left, dark bottom-right) creating a tactile, 3D feel
2. **Press Animations** — Buttons scale down and shadows flatten when pressed, mimicking physical buttons
3. **Floating Action Button** — FAB with rotation animation (plus rotates to X)
4. **Category Filter Pills** — Animated pill selection with color transitions
5. **Quick-Add Product Grid** — 2-column grid with selection border highlights
6. **Animated Credit Balance** — Spring-animated counter that scales in on appear
7. **Inset Text Fields** — Inward shadows create recessed input fields
8. **Neumorphic Badges** — Pill-shaped status indicators (Credit/Settled)
9. **Avatar Initials** — Circular neumorphic avatars with first letter
10. **Live Stats Bar** — Real-time customer count pills with icons

---

## 📊 Changes Summary

```
+1,018 lines added  |  -195 lines removed  |  Net: +823 lines
1 new file (NeumorphicDesign.swift)
5 modified files (all views + print template)
```

---

## 🚀 How to Use

Open `BillingApp.xcodeproj` in Xcode, build & run. The neumorphic design system is automatically applied across all views. All components are reusable — just import `NeumorphicDesign.swift` and use any component.

> **Note:** The `NeumorphicDesign.swift` file must be added to the Xcode project target for the components to be available.
