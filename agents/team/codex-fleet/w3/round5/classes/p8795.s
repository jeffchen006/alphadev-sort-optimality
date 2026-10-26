# n=5 model=out iset=I1 prefix14_class=8795
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovg S0, P3
cmp P0, P1
mov S2, P0
cmovle S2, P1
cmovl P1, P0
cmp P2, S2
cmovge P0, P2
cmovge P2, S2
cmovg S2, P0
mov P3, S0
cmp P3, P1
