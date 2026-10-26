# n=5 model=out iset=I1 prefix14_class=11019
mov S0, P1
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovge P3, S2
cmp P2, P1
mov S1, P0
cmovle P1, P2
cmovle P2, S0
cmp P2, S1
cmovge S1, P2
cmovle P0, P2
cmp P3, P1
cmovl P2, P1
