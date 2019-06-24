
using Random, Printf, Colors

import Luxor
const lx = Luxor

function triangle(points, degree)
    lx.sethue(cols[degree])
    lx.poly(points, :fill)
end

function sierpinski(points, degree)
    triangle(points, degree)
    if degree > 1
        p1, p2, p3 = points
        sierpinski([p1, lx.midpoint(p1, p2),
                        lx.midpoint(p1, p3)], degree-1)
        sierpinski([p2, lx.midpoint(p1, p2),
                        lx.midpoint(p2, p3)], degree-1)
        sierpinski([p3, lx.midpoint(p3, p2),
                        lx.midpoint(p1, p3)], degree-1)
    end
end

function draw(n)
    lx.circle(lx.O, 100, :clip)
    points = lx.ngon(lx.O, 150, 3, -pi/2, vertices=true)
    sierpinski(points, n)
end

lx.Drawing(400, 250)
lx.background("white")
lx.origin()

depth = 8 
cols = distinguishable_colors(depth) # from Colors.jl
draw(depth)

lx.finish()
lx.preview()

import Winston
const wn = Winston

t = collect(range(0,stop=4pi,length=1000));
f(x::Array) = 10x .* exp.(-0.3x) .* sin.(3x);
g(x::Array) = 0.1x.*(2pi .- x).*(4pi .- x);
h(x::Array) = 10.0 ./ (1 .+ x.*x);  # Note need spaces tp clarify 1./ and 1 ./

y1 = f(t) 
y2 = g(t)
y3 = h(t)
wn.plot(t,y1,"b",t,y2,"r--",t,y3,"k;")

x = randn(10000)
wn.plothist(x, nbins=50)

p = wn.FramedPlot( title="Frequency vs Time", ylabel="\\Theta",xlabel="\\Tau");
wn.add(p,wn.FillBetween(t,y1,t,y2));
wn.add(p,wn.Curve(t,y1,color="red"));
wn.add(p,wn.Curve(t,y2,color="blue"));

wn.display(p)

wn.semilogx(t,y1)
wn.title("log(t) vs 10x * exp(-0.3x) * sin(3x)")

wn.semilogy(y2,y3)
wn.title("0.1*(2\\pi - x)*(4\\pi - x)  vs  log(1 /( 1 + x*x))")



p = wn.FramedPlot(aspect_ratio=1,xrange=(-10,110),yrange=(-10,110));
n = 21;
x = collect(range(0.0, length=n, stop=100.0));

# Create a set of random variates

yA =  10.0*randn(n) .+ 40.0;
yB =  x .+ 5.0*randn(n);

# Set labels and symbol styles

a = wn.Points(x, yA, kind="circle");
wn.setattr(a,label="'a' points");

b = wn.Points(x, yB);
wn.setattr(b,label="'b' points");
wn.style(b, kind="filled circle");

# Plot a line which 'fits' through the yB points
# and add a legend in the top LHS part of the graph

s = wn.Slope(1, (0,0), kind="dotted");
wn.setattr(s, label="slope");
lg = wn.Legend(.1, .9, Any[a,b,s] );
wn.add(p, s, a, b, lg);

wn.display(p)

wn.savefig(p, "MyWPlot.png") 

import Cairo
const ca = Cairo

c  = ca.CairoRGBSurface(512, 128);
cr = ca.CairoContext(c);
ca.save(cr);

ca.set_source_rgb(cr, 0.8, 0.8, 0.8);
ca.rectangle(cr, 0.0, 0.0, 512.0, 128.0); # background
ca.fill(cr);
ca.restore(cr);
ca.save(cr);

x0=51.2;  y0=64.0;
x1=204.8; y1=115.4;
x2=307.2; y2=12.8;
x3=460.8; y3=64.0;

ca.move_to(cr, x0, y0);
ca.curve_to(cr, x1, y1, x2, y2, x3, y3);
ca.set_line_width(cr, 10.0);
ca.stroke(cr);
ca.restore(cr);

ca.move_to(cr, 12.0, 12.0);
ca.set_source_rgb(cr, 0, 0, 0);
ca.show_text(cr,"Cairo Curve")
ca.write_to_png(c,"cstroke.png");

run(`display cstroke.png`)

import PyPlot
const py = PyPlot

x = collect(range(0.0,stop=2pi,length=1000))
y = sin.(3*x + 4*cos.(2*x));
py.title("A sinusoidally modulated sinusoid");
py.plot(x, y, color="red", linewidth=2.0, linestyle="--");

y = collect(range(0,stop=3π,length=250))
py.surf(y, y, y .* sin.(y) .* cos.(y)' .* exp.(-0.4y))

py.xkcd()
x = collect(range(1, length=101, stop=10));
y = sin.(3x + cos.(5x))
p = py.plot(x,y)

import Gadfly
gd = Gadfly

dd  =  gd.plot(x =  rand(10),  y = rand(10));
gd.draw(SVG("random-pts.svg",  15cm, 12cm) , dd);

x = collect(1:100);
y1 = ones(100) - 2*rand(100);
y2 = randn(100);

gd.plot(
 gd.layer(x=x,y=y1,gd.Geom.line,gd.Theme(default_color=gd.colorant"red")),
 gd.layer(x=x,y=y2,gd.Geom.line,gd.Theme(default_color=gd.colorant"blue"))
)

using RDatasets, DataFrames;

mlmf = dataset("mlmRev","Gcsemv")
df = mlmf[completecases(mlmf), :]

names(df)

# gd.set_default_plot_size(20cm, 12cm);
gd.plot(df, x="Course", y="Written", color="Gender")

gd.plot((x,y) -> exp.(-x) .* cos.(y), -2, 0.4, 0, 4)

gd.plot((x,y) -> x .* exp.(-(x - floor.(x))).^2 .- y.^2, -8.0, 8, -2.0, 2.0)

import Compose
const cm =  Compose 


function sierpinski(n)
  if n == 0
    cm.compose(cm.context(), cm.polygon([(1,1), (0,1), (1/2, 0)]));
  else
    t = sierpinski(n - 1);
    cm.compose(cm.context(), (cm.context( 1/4, 0, 1/2, 1/2), t),
                             (cm.context( 0, 1/2, 1/2, 1/2), t),
                             (cm.context( 1/2, 1/2, 1/2, 1/2), t));
  end
end


cx1 = compose(sierpinski(1), linewidth(0.2mm),fill(nothing), stroke("black"));
img = SVG("sierp1.svg", 10cm, 8.66cm); draw(img,cx1);

cx3 = compose(sierpinski(3), linewidth(0.2mm),fill(nothing), stroke("black"));
img = SVG("sierp3.svg", 10cm, 8.66cm); draw(img,cx3);

cx5 = compose(sierpinski(5), linewidth(0.2mm),fill(nothing), stroke("black"));
img = SVG("sierp5.svg", 10cm, 8.66cm); draw(img,cx5);


using PGFPlots

p = Axis( [ Plots.Linear(x -> sin.(3x) .* exp.(-0.3x), (0,8),
                         legendentry = L"$\sin(3x)*exp(-0.3x)$"),
            Plots.Linear(x -> sqrt.(x) ./ (1+x.^2), (0,8),
                         legendentry = L"$\sqrt{2x}/(1+x^2)$") 
        ])

# This requires installation of the pdf2svg utility
save("linear-plots.svg", p);

fq  =  randn(10000);
p = Axis(Plots.Histogram(fq, bins=100), ymin=0)

save("histogram-plot.svg", p);


