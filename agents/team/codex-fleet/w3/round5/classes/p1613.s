# n=5 model=out iset=I1 prefix14_class=1613
mov S2, P0
cmp P0, P2
mov S0, P1
cmovle S2, P2
cmovg P0, P2
cmp P3, S0
cmovle P1, P3
cmovg S0, P3
cmovg P3, P1
cmp P0, P1
cmovl P1, P0
cmovl P0, P3
cmp S2, S0
cmovge P3, S0
