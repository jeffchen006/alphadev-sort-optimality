# n=5 model=out iset=I1 prefix14_class=9145
mov S1, P0
cmp P1, S1
cmovle P0, P1
cmovge S1, P1
mov S0, P0
cmp P3, P2
cmovl P1, P2
cmovl P2, P3
cmovl P3, P1
cmp S0, P2
cmovg S0, P2
cmovge P2, P0
cmp S1, P3
cmovl P1, P3
