# n=5 model=out iset=I1 prefix14_class=2664
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovge S1, P3
mov P3, P0
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovg P1, P2
cmp P1, S1
cmovle P2, S1
cmovle S1, P1
cmovle P1, P2
cmp S0, P0
