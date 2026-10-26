# n=5 model=out iset=I1 prefix14_class=1032
mov S1, P3
cmp P3, P1
cmovle P3, P1
cmovl P1, S1
cmp P2, P0
mov S0, P2
mov S1, P3
cmovge P2, P0
cmovge P0, S0
cmp P0, P3
cmovge S1, P0
mov S1, P1
cmovg P0, P3
cmp P1, P2
