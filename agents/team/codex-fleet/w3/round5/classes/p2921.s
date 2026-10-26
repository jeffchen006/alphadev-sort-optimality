# n=5 model=out iset=I1 prefix14_class=2921
mov S1, P0
cmp P2, P0
cmovl P0, P2
mov S0, P3
cmovge S1, P2
cmp P1, S0
cmovg P3, P1
cmovg P1, S0
cmp S1, P3
mov S0, P0
cmovle P2, P3
cmovle P3, S1
cmovle S1, P2
cmp P0, P1
