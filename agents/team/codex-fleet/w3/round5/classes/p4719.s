# n=5 model=out iset=I1 prefix14_class=4719
mov S0, P0
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
cmp S0, P1
cmovg P0, P1
cmovge P1, S0
mov S2, P2
cmovl S0, P1
cmp P3, S0
cmovg S0, P3
cmovle P1, P3
cmp P2, P0
