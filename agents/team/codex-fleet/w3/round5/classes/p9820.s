# n=5 model=out iset=I1 prefix14_class=9820
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
cmovle P2, S1
mov S0, P1
cmp P0, P3
cmovle S1, P3
mov S2, P2
cmovl P3, P0
cmovl P0, S1
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
cmp P1, P3
