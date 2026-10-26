# n=5 model=out iset=I1 prefix14_class=8815
cmp P0, P1
mov S1, P1
cmovle S1, P0
cmovg P1, P0
mov S0, P3
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
mov P0, S0
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
cmovg P2, S2
mov P1, P2
