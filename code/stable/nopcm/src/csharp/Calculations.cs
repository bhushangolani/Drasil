/** \file Calculations.cs
    \author Thulasi Jegatheesan
    \brief Provides functions for calculating the outputs
*/
using System;
using System.Collections.Generic;
using Microsoft.Research.Oslo;

public class Calculations {
    
    /** \brief Calculates volume of water: the amount of space occupied by a given quantity of water (m^3)
        \param V_tank volume of the cylindrical tank: the amount of space encompassed by a tank (m^3)
        \return volume of water: the amount of space occupied by a given quantity of water (m^3)
    */
    public static double func_V_W(double V_tank) {
        return V_tank;
    }
    
    /** \brief Calculates mass of water: the quantity of matter within the water (kg)
        \param rho_W density of water: nass per unit volume of water (kg/m^3)
        \param V_W volume of water: the amount of space occupied by a given quantity of water (m^3)
        \return mass of water: the quantity of matter within the water (kg)
    */
    public static double func_m_W(double rho_W, double V_W) {
        return V_W * rho_W;
    }
    
    /** \brief Calculates ODE parameter for water related to decay time: derived parameter based on rate of change of temperature of water (s)
        \param C_W specific heat capacity of water: the amount of energy required to raise the temperature of a given unit mass of water by a given amount (J/(kg degreeC))
        \param h_C convective heat transfer coefficient between coil and water: the convective heat transfer coefficient that models the thermal flux from the coil to the surrounding water (W/(m^2 degreeC))
        \param A_C heating coil surface area: area covered by the outermost layer of the coil (m^2)
        \param m_W mass of water: the quantity of matter within the water (kg)
        \return ODE parameter for water related to decay time: derived parameter based on rate of change of temperature of water (s)
    */
    public static double func_tau_W(double C_W, double h_C, double A_C, double m_W) {
        return m_W * C_W / (h_C * A_C);
    }
    
    /** \brief Calculates temperature of the water: the average kinetic energy of the particles within the water (degreeC)
        \param T_C temperature of the heating coil: the average kinetic energy of the particles within the coil (degreeC)
        \param t_final final time: the amount of time elapsed from the beginning of the simulation to its conclusion (s)
        \param T_init initial temperature: the temperature at the beginning of the simulation (degreeC)
        \param A_tol absolute tolerance
        \param R_tol relative tolerance
        \param t_step time step for simulation: the finite discretization of time used in the numerical method for solving the computational model (s)
        \param tau_W ODE parameter for water related to decay time: derived parameter based on rate of change of temperature of water (s)
        \return temperature of the water: the average kinetic energy of the particles within the water (degreeC)
    */
    public static List<double> func_T_W(double T_C, double t_final, double T_init, double A_tol, double R_tol, double t_step, double tau_W) {
        List<double> T_W;
        Func<double, Vector, Vector> f = (t, T_W) => {
            return new Vector(1 / tau_W * (T_C - T_W[0]));
        };
        Options opts = new Options();
        opts.AbsoluteTolerance = A_tol;
        opts.RelativeTolerance = R_tol;
        
        Vector initv = new Vector(T_init);
        IEnumerable<SolPoint> sol = Ode.RK547M(0.0, initv, f, opts);
        IEnumerable<SolPoint> points = sol.SolveFromToStep(0.0, t_final, t_step);
        T_W = new List<double> {};
        foreach (SolPoint sp in points) {
            T_W.Add(sp.X[0]);
        }
        
        return T_W;
    }
}
