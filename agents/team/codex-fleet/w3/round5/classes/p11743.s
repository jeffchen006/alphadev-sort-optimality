# n=5 model=out iset=I1 prefix14_class=11743
cmp P0, P3
cmovle S0, P3
cmovg S0, P0
cmovle P3, P0
cmp P1, P2
cmovge P0, P1
cmovge P1, P2
cmovg P2, P0
mov S2, P2
cmp P2, S0
cmovle P2, S0
cmovl S0, S2
mov S2, P1
cmp P3, P1
