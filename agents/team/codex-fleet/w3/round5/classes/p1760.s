# n=5 model=out iset=I1 prefix14_class=1760
mov S0, P2
cmp P0, P2
cmovg S0, P0
cmovg P0, P2
cmp P3, P1
cmovle P2, P3
cmovge P2, P1
cmovl P3, P1
cmp S0, P3
cmovle S1, S0
cmovl S0, P3
mov S0, P0
cmovge S1, P3
cmp S0, P2
