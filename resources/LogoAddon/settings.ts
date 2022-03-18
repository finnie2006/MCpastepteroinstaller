import { action, Action } from 'easy-peasy';

export interface SiteSettings {
    name: string;
    logo_frontend_mode: string;
    logo_mode: string;
    locale: string;
    recaptcha: {
        enabled: boolean;
        siteKey: string;
    };
    analytics: string;
}

export interface SettingsStore {
    data?: SiteSettings;
    setSettings: Action<SettingsStore, SiteSettings>;
}

const settings: SettingsStore = {
    data: undefined,

    setSettings: action((state, payload) => {
        state.data = payload;
    }),
};

export default settings;
