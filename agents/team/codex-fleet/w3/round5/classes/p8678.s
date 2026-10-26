# n=5 model=out iset=I1 prefix14_class=8678
mov S2, P0
cmp P0, P2
cmovl S2, P2
cmovg P0, P2
mov S1, P0
mov P2, S2
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
cmovle P3, S0
cmp P3, S2
cmovg S2, P3
cmovge P3, P2
cmp P1, P0
