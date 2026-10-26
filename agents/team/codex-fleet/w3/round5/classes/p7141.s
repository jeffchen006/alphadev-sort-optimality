# n=5 model=out iset=I1 prefix14_class=7141
mov S1, P1
cmp P1, P3
mov S2, P0
cmovle S1, P3
cmovle P3, P1
cmp P0, P2
cmovl P0, P2
cmovg S2, P2
cmp S2, P3
mov S0, P3
cmovge S0, S2
cmovg S2, P3
cmp S1, P0
cmovg P2, P0
