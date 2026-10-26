# n=5 model=out iset=I1 prefix14_class=1200
mov S0, P3
cmp P3, P0
cmovle P3, P0
cmovl P0, S0
mov S2, P2
cmovle S0, P3
cmp P2, P1
cmovg P2, P1
cmovle S2, P1
cmp S0, S2
cmovg S0, S2
mov P1, S0
cmovge S2, P3
cmp P2, P0
