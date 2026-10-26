# n=5 model=out iset=I1 prefix14_class=13979
cmp P1, P0
mov S1, P2
cmovle S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P2, P3
cmovle S1, P3
cmovge P2, P3
mov P3, S1
cmp P3, P1
cmovg P3, P1
cmovg P1, S1
mov S1, P2
cmp S1, P0
