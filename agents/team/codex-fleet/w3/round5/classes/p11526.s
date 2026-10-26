# n=5 model=out iset=I1 prefix14_class=11526
cmp P2, P1
cmovle S1, P2
cmovle P2, P1
cmovl P1, S1
cmp P3, P0
cmovg S2, P0
cmovle S2, P3
mov S0, S2
cmovle P3, P0
cmp S0, P1
cmovge S0, P1
cmovg P1, S2
cmp P3, P2
mov P0, P1
