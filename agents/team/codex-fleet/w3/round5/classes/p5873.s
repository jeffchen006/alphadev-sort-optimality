# n=5 model=out iset=I1 prefix14_class=5873
mov S2, P0
cmp P2, S2
cmovg S2, P2
cmovge P2, P0
cmp P3, P1
mov S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P3, S2
mov S0, S2
cmovle S0, P3
cmovge S2, P3
cmp P2, P1
cmovle P3, P2
