# n=5 model=out iset=I1 prefix14_class=5643
mov S0, P0
cmp P2, P1
mov S1, P1
cmovg S1, P2
cmovle P1, P2
cmp P3, S0
cmovge P0, P3
cmovl S0, P3
cmp S0, P1
cmovle S2, S0
cmovle S0, P1
cmovg S2, P1
cmp S1, P0
cmovl P3, S1
