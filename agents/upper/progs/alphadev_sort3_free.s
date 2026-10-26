# n=3 iset=I1 model=free source=AlphaDev Sort3AlphaDev, k=11 (= L - 2n), outputs: O0=P0 O1=S1 O2=P1
cmp P2, P1
mov S0, P1
cmovl S0, P2
cmovg P1, P2
cmp P1, P0
mov S1, P0
cmovl S1, P1
cmovle P1, P0
cmp S0, S1
cmovle P0, S0
cmovg S1, S0
