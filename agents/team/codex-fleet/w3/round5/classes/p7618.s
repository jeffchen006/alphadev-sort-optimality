# n=5 model=out iset=I1 prefix14_class=7618
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmovle P1, S2
cmp P0, P3
mov S1, P3
cmovle S1, P0
mov S0, P1
cmovge P3, P0
cmp P1, S1
cmovge S0, S1
mov S0, P3
cmovge S1, P1
cmp P2, P3
