# n=5 model=out iset=I1 prefix14_class=12056
mov S2, P0
cmp P1, S2
cmovge P0, P1
mov S0, P3
cmovge P1, S2
mov S1, P0
cmp P3, P2
cmovg S0, P2
cmovle P3, P2
cmp P1, S0
cmovle S2, S0
cmovl S0, P1
cmovle P1, S2
cmp S1, P3
