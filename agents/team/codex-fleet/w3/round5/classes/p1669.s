# n=5 model=out iset=I1 prefix14_class=1669
cmp P1, P0
mov S0, P3
mov S1, P0
cmovl P0, P1
cmovle P1, S1
cmp P3, P2
cmovge P3, P2
cmovg P2, S0
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
cmovle S0, P3
mov P0, P1
cmp P1, P2
