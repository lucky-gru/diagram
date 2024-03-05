import { createRoot } from 'react-dom/client';
import { App } from '~/App';

import 'tailwindcss/tailwind.css';

document.body.classList.add('font-sans', 'antialiased');

const root = createRoot(document.getElementById('root')!);

root.render(<App />);
