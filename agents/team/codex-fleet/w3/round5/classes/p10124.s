# n=5 model=out iset=I1 prefix14_class=10124
cmp P2, P3
cmovg S0, P3
mov S1, P0
cmovge P3, P2
cmovle S0, P2
cmp P0, P1
cmovg S1, P1
cmovle P0, P1
cmp P3, P0
cmovl P2, P0
cmovl P0, P3
cmovl P3, P2
mov P1, P0
cmp S0, S1
