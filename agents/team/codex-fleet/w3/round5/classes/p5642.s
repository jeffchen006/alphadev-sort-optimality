# n=5 model=out iset=I1 prefix14_class=5642
mov S1, P2
cmp P3, P2
mov S0, P1
cmovg S1, P3
cmovle P2, P3
cmp P0, P1
cmovl S0, P0
cmovge P1, P0
cmp S0, P2
mov S2, S0
cmovg S2, P2
cmovle S0, P2
mov S2, P1
cmp S2, S1
