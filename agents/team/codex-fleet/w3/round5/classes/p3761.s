# n=5 model=out iset=I1 prefix14_class=3761
mov S2, P0
mov S1, P1
cmp P2, S1
cmovge P1, P2
cmovl S1, P2
cmp P3, S2
cmovg S2, P3
mov S0, S1
cmovg P3, P0
cmp S0, P3
cmovle S1, P3
cmovle P3, S0
cmp P1, S2
cmovle P0, P1
