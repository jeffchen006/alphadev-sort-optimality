# n=5 model=out iset=I1 prefix14_class=12997
mov S2, P1
cmp S2, P0
cmovl P1, P0
cmovle P0, S2
cmp P3, P2
mov S1, P2
mov S2, P1
cmovle S1, P3
cmovle P3, P2
cmp P0, S1
cmovg S0, S1
cmovge S1, P0
cmovg P0, S0
cmp S2, P3
