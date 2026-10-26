# n=5 model=out iset=I1 prefix14_class=11923
cmp P3, P2
mov S1, P3
cmovle P3, P2
cmovl P2, S1
mov S1, P1
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
cmp P3, S1
cmovge S0, S1
cmovg S1, P3
mov S1, P0
cmovg P3, S0
cmp S1, P2
