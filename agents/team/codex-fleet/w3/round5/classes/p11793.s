# n=5 model=out iset=I1 prefix14_class=11793
cmp P1, P0
cmovle S1, P0
mov S0, P2
cmovle P0, P1
cmovg S1, P1
cmp P3, S0
cmovl S0, P3
cmovl P3, P2
cmp S1, P3
cmovge S2, P3
cmovge P3, S1
cmovg S1, S2
cmp S0, P0
cmovl P1, P0
