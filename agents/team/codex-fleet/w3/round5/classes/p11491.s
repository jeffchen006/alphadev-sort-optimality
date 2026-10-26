# n=5 model=out iset=I1 prefix14_class=11491
mov S2, P3
cmp P3, P0
mov S0, P1
cmovle P3, P0
cmovle P0, S2
cmp S0, P2
cmovg P1, P2
cmovl S0, P2
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P3, S0
cmovge P1, P3
