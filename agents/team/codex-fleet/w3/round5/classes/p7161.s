# n=5 model=out iset=I1 prefix14_class=7161
mov S1, P1
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmp P3, P2
cmovle P1, P2
cmovl P2, P3
cmovl P3, P1
cmp P0, P2
mov S0, P0
cmovg S0, P2
cmovle P0, P2
mov S0, P0
cmp P3, S1
