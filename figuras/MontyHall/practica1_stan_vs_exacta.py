import cmdstanpy
import numpy as np
import os
import matplotlib.pyplot as plt
import matplotlib.backends.backend_pdf
import math
import pandas as pd
pdf = matplotlib.backends.backend_pdf.PdfPages("practica1_stan_vs_exacta.pdf")
plt.rcParams.update({'font.size': 16})
cmap = plt.get_cmap("tab10") # Colores para los modelos
# # #

stan_code = """
data {
  int<lower=1> N;
  array[N] int<lower=0, upper=2> c;
  array[N] int<lower=0, upper=2> s;
  array[N] int<lower=0, upper=2> r;
}

parameters {
  real<lower=0, upper=1> p;
}

model {
  // Prior
  p ~ uniform(0, 1);

  // Likelihood
  for (i in 1:N) {
    real log_prob_m0;
    if (s[i] == r[i]) {
      log_prob_m0 = negative_infinity();
    } else {
      log_prob_m0 = log(0.5);
    }

    real log_prob_m1;
    if (r[i] == c[i]) {
      if (s[i] == r[i]) {
        log_prob_m1 = negative_infinity();
      } else {
        log_prob_m1 = log(0.5);
      }
    } else {
      if (s[i] != r[i] && s[i] != c[i]) {
        log_prob_m1 = log(1.0);
      } else {
        log_prob_m1 = negative_infinity();
      }
    }

    target += log_mix(p, log_prob_m1, log_prob_m0);
  }
}
"""

# Guardar el código en un archivo .stan
stan_file = 'monty_hall_model.stan'
with open(stan_file, 'w') as f:
    f.write(stan_code)


model = cmdstanpy.CmdStanModel(stan_file=stan_file)

data = pd.read_csv("datos/NoMontyHall.csv")


# Preparar los datos para Stan
stan_data = {
    'N': len(list(data.c)),
    'c': list(data.c),
    's': list(data.s),
    'r': list(data.r)
}

fit = model.sample(
    data=stan_data,
    seed=123,
    chains=4,
    iter_warmup=500,
    iter_sampling=1000
)


fit

print(fit.summary())

# Extraer y mostrar el posterior de 'p'
p_posterior_summary = fit.summary().loc['p']
mean_p = p_posterior_summary['Mean']
ci_5 = p_posterior_summary['5%']
ci_95 = p_posterior_summary['95%']


posterior_samples = fit.draws_pd()
import matplotlib.pyplot as plt
import numpy as np

Datos = data
no_podemos_saber_si_se_olvida = sum((Datos.c == Datos.r))
seguro_se_olvida = sum((Datos.c != Datos.r) & (Datos.c == Datos.s))
quizas_no_se_haya_olvidado = sum((Datos.c != Datos.r) & (Datos.c != Datos.s))
p_grilla = np.arange(0.01,1.001,0.001)
exponente_posterior = seguro_se_olvida * np.log(1-p_grilla) + quizas_no_se_haya_olvidado*np.log(1+p_grilla)



plt.plot(p_grilla, np.exp(exponente_posterior)/sum(np.exp(exponente_posterior)*0.001), linewidth=2, alpha=0.75)
plt.hist(posterior_samples.p, density=True, bins=p_grilla)
plt.axvline(x=0.75, color='gray', linestyle='--', label='True value')
plt.title('Distribución Posterior del Parámetro p', fontsize=16)
plt.xlabel('Valor de p', fontsize=12)
plt.ylabel('Densidad', fontsize=12)
plt.tight_layout()
pdf.savefig(bbox_inches='tight')
plt.close()


# # #
pdf.close()


